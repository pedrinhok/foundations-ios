import Foundation
import FirebaseAuth
import FirebaseDatabase

class SubscribeService {
    
    // TODO: Fazer este get com query com a data e horario para verificar se ainda está dispoível o jogo
    public static func get(handler: @escaping ([String]) -> ()) {
        let ref = Database.database().reference()
        
        guard let user = UserService.current() else {
            handler([])
            return
        }
        
        ref.child("subscribe").queryOrdered(byChild: "subscribed").queryEqual(toValue: user.id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var mySubscriptions: [String] = []
            
            for data in snapshot.children {
                guard let snapshot = data as? DataSnapshot else { continue }
                guard let value = snapshot.value as? [String: Any] else { continue }
                
                let match = value["match"] as? String ?? ""
                mySubscriptions.append(match)
            }
            
            handler(mySubscriptions)
            
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
        
        if user.id == match.creator {
            handler("This's your match, idiot")
            return
        }
        
        let ref = Database.database().reference()
        
        let match = match.matchId
        let subscribed = user.id
        
        
        ref.child("subscribe").childByAutoId().setValue(["match": match, "subscribed": subscribed])
        
        handler(nil)
    }

}
