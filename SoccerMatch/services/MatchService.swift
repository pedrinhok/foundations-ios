import Foundation
import FirebaseAuth
import FirebaseDatabase

class MatchService {

    public static func create(_ match: Match, handler: (String?) -> ()) {
        guard let user = UserService.current() else {
            handler("Unauthorized!")
            return
        }
        var m = match
        m.creator = user.id

        let JSON = try! JSONEncoder().encode(m)
        let data = try! JSONSerialization.jsonObject(with: JSON, options: [])

        let ref = Database.database().reference()
        ref.child("matches").childByAutoId().setValue(data)

        handler(nil)
    }

}
