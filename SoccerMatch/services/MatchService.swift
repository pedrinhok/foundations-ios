import Foundation
import FirebaseAuth
import FirebaseDatabase

class MatchService {
    
    public static func getMatchCreator(userRef: String!, handler: @escaping (UserObject?) -> ()) {
        let ref = Database.database().reference()
        
        ref.child("users").child(userRef).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let user = UserObject()
            let value = snapshot.value as? NSDictionary
            
            user.id = userRef
            user.email = value?["email"] as? String ?? ""
            user.name = value?["name"] as? String ?? ""
            user.phone = value?["phone"] as? String ?? ""
            
            handler(user)
            
        }) { (error) in
            print(error.localizedDescription)
            handler(nil)
        }
    }

    public static func get(handler: @escaping ([Match]) -> ()) {
        let ref = Database.database().reference()

        ref.child("matches").observeSingleEvent(of: .value, with: { (snapshot) in

            var matches: [Match] = []

            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let data = snapshot.value as? [String: Any] else { continue }
                let match = Match.decode(data)
                matches.append(match)
            }

            handler(matches)

        }) { (error) in
            print(error.localizedDescription)
            handler([])
        }
    }

    public static func create(_ match: Match, handler: (String?) -> ()) {
        guard let user = UserService.current() else {
            handler("Unauthorized!")
            return
        }

        let ref = Database.database().reference()
        
        var m = match
        m.matchId = ref.child("matches").childByAutoId().key
        m.creator = user.id

        let JSON = try! JSONEncoder().encode(m)
        let data = try! JSONSerialization.jsonObject(with: JSON, options: [])

        ref.child("matches").child(m.matchId!).setValue(data)

        handler(nil)
    }

}
