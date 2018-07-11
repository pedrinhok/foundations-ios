import Foundation

struct Subscription: Codable {
    
    var ref: String?
    var match: Match?
    var user: User?
    var accepted: Bool?
    
}
