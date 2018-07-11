import UIKit

class SelectMatchViewController: UIViewController {
    
    var match: Match!
    var creator: User!
    var subscriptions: [User] = []
    
    @IBOutlet weak var creatorName: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var vacancies: UILabel!
    @IBOutlet weak var phone: UIImageView!
    @IBOutlet weak var buttonSubscribe: StandardButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        desc.text = match.desc
        location.text = match.location
        day.text = match.day
        schedule.text = "\(match.start!) - \(match.finish!)"
        price.text = match.price
        vacancies.text = match.vacancies
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickPhone))
        phone.isUserInteractionEnabled = true
        phone.addGestureRecognizer(tap)
        
        getCreator()
        getSubscriptions()
    }
    
    func getCreator() {
        let current = UserService.current()!
        
        if match.creator == current.ref {
            buttonSubscribe.disable()
            buttonSubscribe.setTitle("You created the match", for: .normal)
        }
        
        MatchService.getCreator(match) { (user) in
            if let user = user {
                self.creator = user
                self.creatorName.text = user.name
            }
        }
    }
    
    func getSubscriptions() {
        let current = UserService.current()!
        
        SubscriptionService.getUsers(match: match.ref!) { (users) in
            self.subscriptions = users
            
            if users.contains(where: { $0.ref == current.ref }) {
                self.buttonSubscribe.disable()
                self.buttonSubscribe.setTitle("You're already subscribed", for: .normal)
            }
        }
    }
    
    func showMessage(title: String, message: String, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
            if let completion = completion { completion() }
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @IBAction func clickSubscribe(_ sender: UIButton) {
        SubscriptionService.create(match) { (error) in
            if let error = error {
                self.showMessage(title: "Wops", message: error)
            } else {
                self.showMessage(title: "You have successfully subscribed to the match!", message: "") {
                    self.performSegue(withIdentifier: "unwindHome", sender: nil)
                }
            }
        }
    }
    
    @objc func clickPhone(tap: UITapGestureRecognizer) {
        showMessage(title: creator.phone ?? "", message: "")
    }
    
}
