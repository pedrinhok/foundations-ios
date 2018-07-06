import UIKit

class SelectMatchViewController: UIViewController {

    var match: Match!

    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var scheduleDate: UILabel!
    @IBOutlet weak var scheduleDuration: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var vacancies: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserService.getMatchCreator(userRef: match.creator) { (user) in
            guard let user = user else {
                self.showMessage("Match crashed")
                return
            }
            self.creator.text = user.name
            self.desc.text = self.match.desc
            self.location.text = self.match.location
            self.scheduleDate.text = self.match.day
            self.scheduleDuration.text = "\(self.match.start!) - \(self.match.finish!)"
            self.price.text = self.match.price
            self.vacancies.text = self.match.vacancies
        }
    }
    
    @IBAction func subscriveToMatch(_ sender: UIButton) {
        SubscribeService.create(match) { (error) in
            if let error = error {
                self.showMessage(error)
                return
            }
            self.performSegue(withIdentifier: "unwindSelectMatch", sender: nil)
        }
    }
    
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Wops", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
            self.performSegue(withIdentifier: "unwindSelectMatch", sender: nil)
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
