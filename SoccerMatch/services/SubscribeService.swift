import Foundation
import FirebaseAuth
import FirebaseDatabase

class SubscribeService {
    
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
        
        let creator = match.creator
        let subscribed = user.id
        
        
        ref.child("subscribe").childByAutoId().setValue(["creator": creator, "subscribed": subscribed])
        
        handler(nil)
    }

}
