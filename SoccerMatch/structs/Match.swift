import Foundation

struct Match: Codable {
    
    var ref: String?
    var creator: String?
    var desc: String?
    var day: String?
    var start: String?
    var finish: String?
    var type: String?
    var vacancies: String?
    var price: String?
    var location: String?
    var x: Double?
    var y: Double?
    var completed: Bool?
    
    static func decode(_ data: [String: Any]) -> Match {
        var match = Match()
        
        if let ref = data["ref"] as? String {
            match.ref = ref
        }
        if let creator = data["creator"] as? String {
            match.creator = creator
        }
        if let desc = data["desc"] as? String {
            match.desc = desc
        }
        if let day = data["day"] as? String {
            match.day = day
        }
        if let start = data["start"] as? String {
            match.start = start
        }
        if let finish = data["finish"] as? String {
            match.finish = finish
        }
        if let type = data["type"] as? String {
            match.type = type
        }
        if let vacancies = data["vacancies"] as? String {
            match.vacancies = vacancies
        }
        if let price = data["price"] as? String {
            match.price = price
        }
        if let location = data["location"] as? String {
            match.location = location
        }
        if let x = data["x"] as? Double {
            match.x = x
        }
        if let y = data["y"] as? Double {
            match.y = y
        }
        if let completed = data["completed"] as? Bool {
            match.completed = completed
        }
        
        return match
    }
    
}
