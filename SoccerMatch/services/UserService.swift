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
        ref.child("users").child(user.ref!).setValue(dict)
        
        AppDelegate.saveContext()
        handler(nil)
    }

    public static func changePassword(password: String, completion: @escaping (String?) -> ()) {
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            if let error = error as? String {
                completion(error.description)
            } else {
                completion(nil)
            }
        }
    }

    public static func create(name: String, phone: String, email: String, password: String, completion: @escaping (String?) -> ()) {
        signout()
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            guard let auth = res?.user else {
                completion("An error has occured!")
                return
            }
            
            let db = Database.database().reference()
            db.child("users").child(auth.uid).setValue(["ref": auth.uid, "name": name, "phone": phone, "email": email])
            
            let user = ManagedUser(context: AppDelegate.persistentContainer.viewContext)
            user.ref = auth.uid
            user.name = name
            user.phone = phone
            user.email = email
            
            AppDelegate.saveContext()
            completion(nil)
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

    public static func find(_ ref: String, completion: @escaping (User?) -> ()) {
        let db = Database.database().reference()
        
        db.child("users").child(ref).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let data = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            let user = User.decode(data)
            
            completion(user)
            
        }) { (error) in completion(nil) }
    }

    public static func signin(email: String, password: String, completion: @escaping (String?) -> ()) {
        signout()

        Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
            
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            guard let auth = res?.user else {
                completion("An error has occured!")
                return
            }
            
            let db = Database.database().reference()
            db.child("users").child(auth.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let data = snapshot.value as? [String: Any] else {
                    completion("An error has occured!")
                    return
                }
                
                let user = ManagedUser(context: AppDelegate.persistentContainer.viewContext)
                user.ref = auth.uid
                user.name = data["name"] as? String ?? ""
                user.phone = data["phone"] as? String ?? ""
                user.email = data["email"] as? String ?? ""
                user.birthday = data["birthday"] as? String ?? ""
                user.gender = data["gender"] as? String ?? ""
                
                AppDelegate.saveContext()
                completion(nil)
                
            }) { (error) in completion(error.localizedDescription) }
        }
    }

    public static func signout(completion: (() -> ())? = nil) {
        
        do { try Auth.auth().signOut() } catch {}
        
        if let user = current() {
            AppDelegate.persistentContainer.viewContext.delete(user)
        }
        
        AppDelegate.saveContext()
        if let completion = completion { completion() }
    }

}
