import Foundation
import FirebaseAuth
import FirebaseDatabase

class MatchService {

    private static let db = Database.database().reference()

    public static func create(_ match: Match, completion: (String?) -> ()) {
        guard let user = UserService.current() else {
            completion("Unauthorized!")
            return
        }
        
        var m = match
        m.ref = db.child("matches").childByAutoId().key
        m.creator = user.ref
        
        let JSON = try! JSONEncoder().encode(m)
        let data = try! JSONSerialization.jsonObject(with: JSON, options: [])
        
        db.child("matches").child(m.ref!).setValue(data)
        
        completion(nil)
    }

    public static func find(_ ref: String, completion: @escaping (Match?) -> ()) {
        db.child("matches").child(ref).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let data = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            let match = Match.decode(data)
            
            completion(match)
            
        }) { (error) in completion(nil) }
    }

    public static func home(completion: @escaping ([Match]) -> ()) {
        
        var request = db.child("matches") as DatabaseQuery
        
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy"
        let currentDate = dateFormater.string(from: date)
        
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "HH:mm"
        let currentTime = timeFormater.string(from: date)
        
        request = request.queryOrdered(byChild: "day").queryStarting(atValue: currentDate)
        
        request.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var matches: [Match] = []
            
            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let data = snapshot.value as? [String: Any] else { continue }
                let match = Match.decode(data)
                if match.finish! < currentTime {
                    continue
                }
                matches.append(match)
            }
            
            completion(matches)
            
        }) { (error) in completion([]) }
    }

    public static func get(creator: String? = nil, completion: @escaping ([Match]) -> ()) {

        var request = db.child("matches") as DatabaseQuery

        if let creator = creator {
            request = request.queryOrdered(byChild: "creator").queryEqual(toValue: creator)
        }

        request.observeSingleEvent(of: .value, with: { (snapshot) in

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
        db.child("users").child(match.creator!).observeSingleEvent(of: .value, with: { (snapshot) in

            let data = snapshot.value as! [String: Any]
            let user = User.decode(data)

            completion(user)

        }) { (error) in completion(nil) }
    }

}
