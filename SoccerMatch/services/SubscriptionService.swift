import Foundation
import FirebaseAuth
import FirebaseDatabase

class SubscriptionService {

    private static let db = Database.database().reference()

    public static func getMatches(user: String? = nil, completion: @escaping ([Match]) -> ()) {

        var ref: String!
        if let user = user {
            ref = user
        } else {
            ref = UserService.current()!.ref
        }

        db.child("subscriptions").queryOrdered(byChild: "user").queryEqual(toValue: ref).observeSingleEvent(of: .value, with: { (snapshot) in
            
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

        guard let user = UserService.current() else {
            completion("Unauthorized!")
            return
        }

        db.child("subscriptions").childByAutoId().setValue(["match": match.ref, "user": user.ref])

        completion(nil)
    }

}
