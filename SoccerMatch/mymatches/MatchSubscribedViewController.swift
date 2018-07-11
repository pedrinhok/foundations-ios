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
        
        desc.text = subscription.match!.desc
        location.text = subscription.match!.location
        day.text = subscription.match!.day
        schedule.text = "\(subscription.match!.start!) - \(subscription.match!.finish!)"
        price.text = subscription.match!.price
        vacancies.text = subscription.match!.vacancies
        
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
