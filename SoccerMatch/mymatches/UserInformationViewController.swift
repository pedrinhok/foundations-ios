import UIKit

class UserInformationViewController: UIViewController {
    
    var subscription: Subscription!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var numberCreated: UILabel!
    @IBOutlet weak var numberSubscriptions: UILabel!
    @IBOutlet weak var buttonAccept: StandardButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        name.text = subscription.user!.name
        phone.text = subscription.user!.phone
        
        if subscription.accepted {
            buttonAccept.disable()
            buttonAccept.setTitle("Accepted", for: .normal)
        }
        
        if Int(self.subscription.match!.vacancies!)! < 1 {
            buttonAccept.disable()
            buttonAccept.setTitle("Vacancies already filled", for: .normal)
        }
        
        getMatches()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "unwindMatchCreated":
            guard let vc = segue.destination as? MatchCreatedViewController else { return }
            vc.match = subscription.match
            return
            
        case .none, .some(_):
            return
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
        let v = Int(self.subscription.match!.vacancies!)!
        
        SubscriptionService.accept(subscription) { (error) in
            if let error = error {
                self.showMessage(title: "Wops", message: error)
            } else {
                self.subscription.match!.vacancies! = String(v - 1)
                
                self.showMessage(title: "User successfully accepted!", message: "") {
                    self.performSegue(withIdentifier: "unwindMatchCreated", sender: nil)
                }
            }
        }
    }
    
}
