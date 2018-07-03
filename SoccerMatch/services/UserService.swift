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

        print("1")
        var erro: String?
        
        if Auth.auth().currentUser != nil {
            try! Auth.auth().signOut()
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in

            print("2")
            guard let email = authResult?.user.email, error == nil else {
                print("ERRRRO -> \(error!)")
                erro = "\(error!)"
                handler(erro)
                return
            }

            let ref = Database.database().reference()
            
            let userAuth = Auth.auth().currentUser!
            ref.child("users").child(userAuth.uid).setValue(["name": name, "phone": phone, "email": email])
            
            if let user = current() {
                AppDelegate.persistentContainer.viewContext.delete(user)
            }
            
            let user = ManagedUser(context: AppDelegate.persistentContainer.viewContext)
            user.name = name
            user.phone = phone
            user.email = email
            user.password = password
            
            AppDelegate.saveContext()
            handler(nil)
        }
//        print(erro)
//
//        if erro != nil {
//            return erro
//        }
//
//        let ref = Database.database().reference()
//
//        let userAuth = Auth.auth().currentUser!
//        ref.child("users").child(userAuth.uid).setValue(["name": name, "phone": phone, "email": email])
//
//        if let user = current() {
//            AppDelegate.persistentContainer.viewContext.delete(user)
//        }
//
//        let user = ManagedUser(context: AppDelegate.persistentContainer.viewContext)
//        user.name = name
//        user.phone = phone
//        user.email = email
//        user.password = password
//
//        AppDelegate.saveContext()
//        return nil
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
