import UIKit

class MatchCreatedViewController: UIViewController {
    
    var match: Match!
    var subscriptions: [User] = []
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var vacancies: UILabel!
    @IBOutlet weak var tableSubscriptions: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableSubscriptions.dataSource = self
        tableSubscriptions.delegate = self
        heightConstraint.constant = 0

        desc.text = match.desc
        location.text = match.location
        day.text = match.day
        schedule.text = "\(match.start!) - \(match.finish!)"
        price.text = match.price
        vacancies.text = match.vacancies
        
        getSubscriptions()
    }
    
    func getSubscriptions() {
        SubscriptionService.getUsers(match: match) { (users) in
            self.subscriptions = users
            self.tableSubscriptions.reloadData()
            self.heightConstraint.constant = CGFloat(users.count) * self.tableSubscriptions.rowHeight
        }
    }

}

extension MatchCreatedViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionCell", for: indexPath) as! SubscriptionCell
        let user = subscriptions[indexPath.row]
        cell.name.text = user.name
        return cell
    }

}
