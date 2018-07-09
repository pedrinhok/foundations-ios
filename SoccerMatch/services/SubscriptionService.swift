import Foundation
import FirebaseAuth
import FirebaseDatabase

class SubscriptionService {

    public static func getMatches(completion: @escaping ([Match]) -> ()) {
        let ref = Database.database().reference()
        
        guard let user = UserService.current() else {
            completion([])
            return
        }
        
        ref.child("subscriptions").queryOrdered(byChild: "user").queryEqual(toValue: user.id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let requests = DispatchGroup()
            var matches: [Match] = []
            
            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let data = snapshot.value as? [String: Any] else { continue }
                guard let m = data["match"] as? String else { continue }

                requests.enter()
                MatchService.find(m) { (match) in
                    matches.append(match!)
                    requests.leave()
                }
            }

            requests.notify(queue: .main) {
                completion(matches)
            }

        }) { (error) in completion([]) }
    }

    public static func create(_ match: Match, handler: (String?) -> ()) {
        let ref = Database.database().reference()

        guard let user = UserService.current() else {
            handler("Unauthorized!")
            return
        }

        ref.child("subscriptions").childByAutoId().setValue(["match": match.matchId, "user": user.id])

        handler(nil)
    }

}
