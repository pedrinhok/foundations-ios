import Foundation
import CoreData
import FirebaseAuth
import FirebaseDatabase

class UserService {
    
    public static func auth() -> Bool {
        return current() != nil
    }

    // TODO - submit post request
    public static func create(name: String, phone: String, email: String, password: String, handler: @escaping (_ error: String?) -> ()) {

        var erro: String?
        
        if Auth.auth().currentUser != nil {
            try! Auth.auth().signOut()
        }
        
        if let user = current() {
            AppDelegate.persistentContainer.viewContext.delete(user)
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            guard let uid = authResult?.user.uid, error == nil else {
                erro = error!.localizedDescription
                handler(erro)
                return
            }

            let ref = Database.database().reference()
            
            ref.child("users").child(uid).setValue(["name": name, "phone": phone, "email": email])
            
            let user = ManagedUser(context: AppDelegate.persistentContainer.viewContext)
            user.id = uid
            user.name = name
            user.phone = phone
            user.email = email
            
            AppDelegate.saveContext()
            handler(nil)
        }
    }
    
    public static func signIn(email: String, password: String, handler: @escaping (_ error: String?) -> ()) {
        if Auth.auth().currentUser != nil {
            
            if Auth.auth().currentUser != nil {
                try! Auth.auth().signOut()
            }
            
            if let user = current() {
                AppDelegate.persistentContainer.viewContext.delete(user)
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                guard let uid = user?.user.uid, error == nil else {
                    handler(error!.localizedDescription)
                    return
                }
                
                let ref = Database.database().reference()
                
                ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    let email = value?["email"] as? String ?? ""
                    let name = value?["name"] as? String ?? ""
                    let phone = value?["phone"] as? String ?? ""
                    
                    let user = ManagedUser(context: AppDelegate.persistentContainer.viewContext)
                    user.id = uid
                    user.name = name
                    user.phone = phone
                    user.email = email
                    
                    AppDelegate.saveContext()
                    handler(nil)
                    
                }) { (error) in
                    handler(error.localizedDescription)
                }
            }
        }
    }

    // TODO - submit get request
    public static func current() -> ManagedUser? {
        do {
            let request: NSFetchRequest<ManagedUser> = ManagedUser.fetchRequest()
            let response = try AppDelegate.persistentContainer.viewContext.fetch(request)
            return response.first
        } catch {
            return nil
        }
    }

}
