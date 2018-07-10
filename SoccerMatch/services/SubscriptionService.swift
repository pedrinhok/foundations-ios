import Foundation
import FirebaseAuth
import FirebaseDatabase

class SubscriptionService {

    public static func getMatches(completion: @escaping ([Match]) -> ()) {
        let db = Database.database().reference()
        
        guard let user = UserService.current() else {
            completion([])
            return
        }
        
        db.child("subscriptions").queryOrdered(byChild: "user").queryEqual(toValue: user.ref).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let requests = DispatchGroup()
            var matches: [Match] = []
            
            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let data = snapshot.value as? [String: Any] else { continue }
                guard let ref = data["match"] as? String else { continue }

                requests.enter()
                MatchService.find(ref) { (match) in
                    if let match = match {
                        matches.append(match)
                    }
                    requests.leave()
                }
            }

            requests.notify(queue: .main) {
                completion(matches)
            }

        }) { (error) in completion([]) }
    }

    public static func getUsers(match: Match, completion: @escaping ([User]) -> ()) {
        let db = Database.database().reference()
        
        db.child("subscriptions").queryOrdered(byChild: "match").queryEqual(toValue: match.ref).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let requests = DispatchGroup()
            var users: [User] = []
            
            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let data = snapshot.value as? [String: Any] else { continue }
                guard let ref = data["user"] as? String else { continue }
                
                requests.enter()
                UserService.find(ref) { (user) in
                    if let user = user {
                        users.append(user)
                    }
                    requests.leave()
                }
            }
            
            requests.notify(queue: .main) {
                completion(users)
            }
            
        }) { (error) in completion([]) }
    }

    public static func create(_ match: Match, completion: (String?) -> ()) {
        let db = Database.database().reference()

        guard let user = UserService.current() else {
            completion("Unauthorized!")
            return
        }

        db.child("subscriptions").childByAutoId().setValue(["match": match.ref, "user": user.ref])

        completion(nil)
    }

}
