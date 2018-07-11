import UIKit

class MatchSubscribedViewController: UIViewController {
    
    var subscription: Subscription!
    var creator: User!
    
    @IBOutlet weak var creatorName: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var vacancies: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var accepted: CircleImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let match = subscription.match!
        
        desc.text = match.desc
        location.text = match.location
        day.text = match.day
        schedule.text = "\(match.start!) - \(match.finish!)"
        price.text = match.price
        vacancies.text = match.vacancies
        
        if let data = subscription.accepted, data {
            accepted.isHidden = false
            status.text = "Subscription accepted"
        } else {
            accepted.isHidden = true
            status.text = "Subscription not accepted"
        }
        if match.finished() {
            status.text = "Match finished"
        }
        
        getCreator()
    }
    
    func getCreator() {
        MatchService.getCreator(subscription.match!) { (user) in
            if let user = user {
                self.creator = user
                self.creatorName.text = user.name
            }
        }
    }
    
}
