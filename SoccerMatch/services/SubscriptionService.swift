import Foundation
import FirebaseAuth
import FirebaseDatabase

class SubscriptionService {
    
    private static let db = Database.database().reference()
    
    public static func getMatches(user: String, completion: @escaping ([Match]) -> ()) {
        var request = db.child("subscriptions") as DatabaseQuery
        
        request = request.queryOrdered(byChild: "user").queryEqual(toValue: user)
        
        request.observeSingleEvent(of: .value) { (snapshot) in
            
            let requests = DispatchGroup()
            var matches: [Match] = []
            
            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let data = snapshot.value as? [String: Any] else { continue }
                
                guard let match = data["match"] as? String else { continue }
                
                requests.enter()
                MatchService.find(match) { (match) in
                    if let match = match {
                        matches.append(match)
                    }
                    requests.leave()
                }
            }
            
            requests.notify(queue: .main) {
                completion(matches)
            }
        }
    }
    
    public static func getUsers(match: String, completion: @escaping ([User]) -> ()) {
        var request = db.child("subscriptions") as DatabaseQuery
        
        request = request.queryOrdered(byChild: "match").queryEqual(toValue: match)
        
        request.observeSingleEvent(of: .value) { (snapshot) in
            
            let requests = DispatchGroup()
            var users: [User] = []
            
            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let data = snapshot.value as? [String: Any] else { continue }
                
                guard let user = data["user"] as? String else { continue }
                
                requests.enter()
                UserService.find(user) { (user) in
                    if let user = user {
                        users.append(user)
                    }
                    requests.leave()
                }
            }
            
            requests.notify(queue: .main) {
                completion(users)
            }
        }
    }
    
    public static func getSubscriptionsByMatch(_ match: String, completion: @escaping ([Subscription]) -> ()) {
        var subscriptions: [Subscription] = []
        
        var request = db.child("subscriptions") as DatabaseQuery
        
        request = request.queryOrdered(byChild: "match").queryEqual(toValue: match)
        
        request.observeSingleEvent(of: .value) { (snapshot) in
            let requests = DispatchGroup()
            
            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let data = snapshot.value as? [String: Any] else { continue }
                
                guard let user = data["user"] as? String else { continue }
                guard let accepted = data["accepted"] as? Bool else { continue }
                
                requests.enter()
                UserService.find(user) { (user) in
                    if let user = user {
                        let subscription = Subscription(ref: snapshot.key, match: nil, user: user, accepted: accepted)
                        subscriptions.append(subscription)
                    }
                    requests.leave()
                }
            }
            
            requests.notify(queue: .main) {
                completion(subscriptions)
            }
        }
    }
    
    public static func getSubscriptionsByUser(_ user: String, completion: @escaping ([Subscription]) -> ()) {
        var subscriptions: [Subscription] = []
        
        var request = db.child("subscriptions") as DatabaseQuery
        
        request = request.queryOrdered(byChild: "user").queryEqual(toValue: user)
        
        request.observeSingleEvent(of: .value) { (snapshot) in
            let requests = DispatchGroup()
            
            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let data = snapshot.value as? [String: Any] else { continue }
                
                guard let match = data["match"] as? String else { continue }
                guard let accepted = data["accepted"] as? Bool else { continue }
                
                requests.enter()
                MatchService.find(match) { (match) in
                    if let match = match {
                        let subscription = Subscription(ref: snapshot.key, match: match, user: nil, accepted: accepted)
                        subscriptions.append(subscription)
                    }
                    requests.leave()
                }
            }
            
            requests.notify(queue: .main) {
                completion(subscriptions)
            }
        }
    }
    
    public static func accept(_ subscription: Subscription, completion: @escaping (String?) -> ()) {
        guard var match = subscription.match else {
            completion("An error has occured")
            return
        }
        guard let str = match.vacancies, let vacancies = Int(str) else {
            completion("An error has occured")
            return
        }
        if vacancies < 1 {
            completion("Vacancies already filled")
            return
        }
        match.completed = vacancies == 1
        match.vacancies = String(vacancies - 1)
        
        db.child("subscriptions").child(subscription.ref!).updateChildValues(["accepted": true]) { (e, res) in
            
            db.child("matches").child(match.ref!).updateChildValues(["completed": match.completed!, "vacancies": match.vacancies!]) { (e, res) in
                completion(nil)
            }
            
        }
    }
    
    public static func refuse(_ subscription: Subscription, completion: @escaping (String?) -> ()) {
        guard var match = subscription.match else {
            completion("An error has occured")
            return
        }
        guard let str = match.vacancies, let vacancies = Int(str) else {
            completion("An error has occured")
            return
        }
        match.vacancies = String(vacancies + 1)
        
        db.child("subscriptions").child(subscription.ref!).updateChildValues(["accepted": false]) { (e, res) in
            
            db.child("matches").child(match.ref!).updateChildValues(["completed": false, "vacancies": match.vacancies!]) { (e, res) in
                completion(nil)
            }
            
        }
    }
    
    public static func create(_ match: Match, completion: (String?) -> ()) {
        
        guard let user = UserService.current() else {
            completion("Unauthorized!")
            return
        }
        
        db.child("subscriptions").childByAutoId().setValue(["match": match.ref!, "user": user.ref!, "accepted": false])
        
        completion(nil)
    }
    
}
