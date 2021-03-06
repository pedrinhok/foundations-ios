import Foundation

struct User: Codable {
    
    var ref: String?
    var name: String?
    var phone: String?
    var email: String?
    var gender: String?
    var birthday: String?
    var photo: Data?
    
    static func decode(_ data: [String: Any]) -> User {
        var user = User()
        
        if let ref = data["ref"] as? String {
            user.ref = ref
        }
        if let name = data["name"] as? String {
            user.name = name
        }
        if let phone = data["phone"] as? String {
            user.phone = phone
        }
        if let email = data["email"] as? String {
            user.email = email
        }
        if let gender = data["gender"] as? String {
            user.gender = gender
        }
        if let birthday = data["birthday"] as? String {
            user.birthday = birthday
        }
        
        return user
    }
    
}
