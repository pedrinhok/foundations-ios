import Foundation
import CoreData
import FirebaseAuth
import FirebaseDatabase

class UserService {

    public static func auth() -> Bool {
        return current() != nil
    }

    public static func updateUserData(data: User!, handler: @escaping (_ error: String?) -> ()) {
        
        guard let user = current() else {
            handler("Unauthorized")
            return
        }
        
        var dict: [String: String] = [:]
        
        if let name = data.name {
            dict["name"] = name
            user.name = name
        }
        
        if let phone = data.phone {
            dict["phone"] = phone
            user.phone = phone
        }
        
        if let email = data.email {
            dict["email"] = email
            user.email = email
        }
        
        if let gender = data.gender {
            dict["gender"] = gender
            user.gender = gender
        }
        
        if let birth = data.birthday {
            dict["birthday"] = birth
            user.birthday = birth
        }
        
        let ref = Database.database().reference()
        ref.child("users").child(user.id!).setValue(dict)
        
        AppDelegate.saveContext()
        handler(nil)
    }

    // TODO - submit post request
    public static func create(name: String, phone: String, email: String, password: String, handler: @escaping (_ error: String?) -> ()) {

        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        if let user = current() {
            AppDelegate.persistentContainer.viewContext.delete(user)
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            guard let uid = authResult?.user.uid, error == nil else {
                handler(error!.localizedDescription)
                return
            }

            let ref = Database.database().reference()
            
            ref.child("users").child(uid).setValue(["uid": uid, "name": name, "phone": phone, "email": email])
            
            let user = ManagedUser(context: AppDelegate.persistentContainer.viewContext)
            user.id = uid
            user.name = name
            user.phone = phone
            user.email = email
            
            AppDelegate.saveContext()
            handler(nil)
        }
    }
    
    public static func signin(email: String, password: String, handler: @escaping (_ error: String?) -> ()) {
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        if let user = current() {
            AppDelegate.persistentContainer.viewContext.delete(user)
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (AuthResult, error) in
            guard let userAuth = AuthResult?.user, error == nil else {
                handler(error!.localizedDescription)
                return
            }
            
            let ref = Database.database().reference()
            
            ref.child("users").child(userAuth.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let email = value?["email"] as? String ?? ""
                let name = value?["name"] as? String ?? ""
                let phone = value?["phone"] as? String ?? ""
                let gender = value?["gender"] as? String ?? ""
                let birthday = value?["birthday"] as? String ?? ""

                let user = ManagedUser(context: AppDelegate.persistentContainer.viewContext)
                user.id = userAuth.uid
                user.name = name
                user.phone = phone
                user.email = email
                user.birthday = birthday
                user.gender = gender
                
                AppDelegate.saveContext()
                handler(nil)
                
            }) { (error) in
                handler(error.localizedDescription)
            }
        }
    }
    
    public static func logout(handler: @escaping (_ bool: Bool?) -> ()) {
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
        if let user = current() {
            AppDelegate.persistentContainer.viewContext.delete(user)
        }
        
        AppDelegate.saveContext()
        handler(true)
    }
    
    public static func changePassword(password: String, handler: @escaping (_ error: String?) -> ()) {
        
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            if let error = error as? String {
                
                handler(error.description)
                return
            }
            
            handler(nil)
        }
    }

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
