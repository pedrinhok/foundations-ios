import UIKit

class MatchCreatedViewController: UIViewController {
    
    var match: Match!
    var subscriptions: [Subscription] = []
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var vacancies: UILabel!
    @IBOutlet weak var collectionSubscriptions: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionSubscriptions.dataSource = self
        collectionSubscriptions.delegate = self
        heightConstraint.constant = 0
        
        desc.text = match.desc
        location.text = match.location
        day.text = match.day
        schedule.text = "\(match.start!) - \(match.finish!)"
        price.text = match.price
        vacancies.text = match.vacancies
        
        getSubscriptions()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "gotoUserInformation":
            guard let vc = segue.destination as? UserInformationViewController else { return }
            guard var subscription = sender as? Subscription else { return }
            subscription.match = match
            vc.subscription = subscription
            return
            
        case .none, .some(_):
            return
        }
    }
    
    func getSubscriptions() {
        SubscriptionService.getSubscriptionsByMatch(match) { (subscriptions) in
            self.subscriptions = subscriptions
            self.collectionSubscriptions.reloadData()
            self.heightConstraint.constant = CGFloat(subscriptions.count) * self.collectionSubscriptions.rowHeight
        }
    }
    
    @IBAction func unwindMatchCreated(segue: UIStoryboardSegue) {}
    
}

extension MatchCreatedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionCell", for: indexPath) as! SubscriptionCell
        
        let subscription = subscriptions[indexPath.row]
        let user = subscription.user!
        
        cell.name.text = user.name
        
        if subscription.accepted {
            cell.accepted.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let subscription = subscriptions[indexPath.row]
        
        performSegue(withIdentifier: "gotoUserInformation", sender: subscription)
    }
    
}
