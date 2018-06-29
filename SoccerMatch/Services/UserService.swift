import Foundation
import CoreData

class UserService {

    public static func auth() -> Bool {
        return current() != nil
    }

    // TODO - submit post request
    public static func create(name: String, phone: String, email: String, password: String) {

        if let user = current() {
            AppDelegate.persistentContainer.viewContext.delete(user)
        }

        let user = ManagedUser(context: AppDelegate.persistentContainer.viewContext)
        user.name = name
        user.phone = phone
        user.email = email
        user.password = password

        AppDelegate.saveContext()
        return
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
