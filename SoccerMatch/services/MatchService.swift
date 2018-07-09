import Foundation
import FirebaseAuth
import FirebaseDatabase

class MatchService {
    
    public static func find(match: String, completion: @escaping (Match?) -> ()) {
        let ref = Database.database().reference()

        ref.child("matches").child(match).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            let match = Match.decode(data)

            completion(match)

        }) { (error) in completion(nil) }
    }

    public static func createdByMe(completion: @escaping ([Match]) -> ()) {
        let ref = Database.database().reference()

        guard let user = UserService.current() else {
            completion([])
            return
        }

        ref.child("matches").queryOrdered(byChild: "creator").queryEqual(toValue: user.id).observeSingleEvent(of: .value, with: { (snapshot) in
            
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

    public static func get(completion: @escaping ([Match]) -> ()) {
        let ref = Database.database().reference()

        ref.child("matches").observeSingleEvent(of: .value, with: { (snapshot) in

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

    public static func create(_ match: Match, completion: (String?) -> ()) {
        guard let user = UserService.current() else {
            completion("Unauthorized!")
            return
        }

        let ref = Database.database().reference()
        
        var m = match
        m.matchId = ref.child("matches").childByAutoId().key
        m.creator = user.id

        let JSON = try! JSONEncoder().encode(m)
        let data = try! JSONSerialization.jsonObject(with: JSON, options: [])

        ref.child("matches").child(m.matchId!).setValue(data)

        completion(nil)
    }

}
