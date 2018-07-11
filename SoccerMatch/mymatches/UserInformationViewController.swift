import UIKit

class UserInformationViewController: UIViewController {
    
    var subscription: Subscription!
    
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var numberCreated: UILabel!
    @IBOutlet weak var numberSubscriptions: UILabel!
    @IBOutlet weak var buttonAccept: StandardButton!
    @IBOutlet weak var buttonRefuse: StandardButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        name.text = subscription.user!.name
        phone.text = subscription.user!.phone
        
        buttons()
        getMatches()
    }
    
    func buttons() {
        let match = subscription.match!
        
        if match.completed() {
            buttonAccept.inactive()
            buttonAccept.setTitle("Vacancies already filled", for: .normal)
        }
        
        if let accepted = subscription.accepted, accepted {
            buttonAccept.inactive()
            buttonAccept.setTitle("User already accepted", for: .normal)
            buttonRefuse.isHidden = false
        }
    }
    
    func getMatches() {
        MatchService.get(creator: subscription.user!.ref) { (matches) in
            self.numberCreated.text = String(matches.count)
        }
        SubscriptionService.getMatches(user: subscription.user!.ref!) { (matches) in
            self.numberSubscriptions.text = String(matches.count)
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
    
    @IBAction func clickAccept(_ sender: StandardButton) {
        showLoading()
        SubscriptionService.accept(subscription) { (error) in
            if let error = error {
                self.showMessage(title: "Wops", message: error)
                self.hideLoading()
            } else {
                self.showMessage(title: "User successfully accepted!", message: "") {
                    self.performSegue(withIdentifier: "unwindMatchCreated", sender: nil)
                }
            }
        }
    }
    
    @IBAction func clickRefuse(_ sender: StandardButton) {
        showLoading()
        SubscriptionService.refuse(subscription) { (error) in
            if let error = error {
                self.showMessage(title: "Wops", message: error)
                self.hideLoading()
            } else {
                self.showMessage(title: "User successfully refused!", message: "") {
                    self.performSegue(withIdentifier: "unwindMatchCreated", sender: nil)
                }
            }
        }
    }
    
    func showLoading() {
        viewLoading.isHidden = false
        viewLoading.isUserInteractionEnabled = true
        activityLoading.startAnimating()
    }
    
    func hideLoading() {
        viewLoading.isHidden = true
        viewLoading.isUserInteractionEnabled = false
        activityLoading.stopAnimating()
    }
    
}
