import Foundation
import FirebaseAuth
import FirebaseDatabase

class MatchService {

    public static func create(_ match: Match, completion: (String?) -> ()) {
        guard let user = UserService.current() else {
            completion("Unauthorized!")
            return
        }
        
        let db = Database.database().reference()
        
        var m = match
        m.ref = db.child("matches").childByAutoId().key
        m.creator = user.ref
        
        let JSON = try! JSONEncoder().encode(m)
        let data = try! JSONSerialization.jsonObject(with: JSON, options: [])
        
        db.child("matches").child(m.ref!).setValue(data)
        
        completion(nil)
    }

    public static func find(_ ref: String, completion: @escaping (Match?) -> ()) {
        let db = Database.database().reference()
        
        db.child("matches").child(ref).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let data = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            let match = Match.decode(data)
            
            completion(match)
            
        }) { (error) in completion(nil) }
    }

    public static func get(completion: @escaping ([Match]) -> ()) {
        let db = Database.database().reference()

        db.child("matches").observeSingleEvent(of: .value, with: { (snapshot) in

            var matches: [Match] = []

            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let data = snapshot.value as? [String: Any] else { continue }
                let match = Match.decode(data)
                matches.append(match)
            }

            completion(matches)

        }) { (error) in completion([]) }
    }

    public static func getCreator(_ match: Match, completion: @escaping (User?) -> ()) {
        let db = Database.database().reference()

        db.child("users").child(match.creator!).observeSingleEvent(of: .value, with: { (snapshot) in

            let data = snapshot.value as! [String: Any]
            let user = User.decode(data)

            completion(user)

        }) { (error) in completion(nil) }
    }

    public static func getCreatedByMe(completion: @escaping ([Match]) -> ()) {
        let db = Database.database().reference()
        
        guard let user = UserService.current() else {
            completion([])
            return
        }
        
        db.child("matches").queryOrdered(byChild: "creator").queryEqual(toValue: user.ref).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var matches: [Match] = []
            
            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let data = snapshot.value as? [String: Any] else { continue }
                let match = Match.decode(data)
                matches.append(match)
            }
            
            completion(matches)
            
        }) { (error) in completion([]) }
    }

}
