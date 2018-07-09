import UIKit

class SelectMatchViewController: UIViewController {

    var match: Match!

    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var vacancies: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.desc.text = self.match.desc
        self.location.text = self.match.location
        self.day.text = self.match.day
        self.schedule.text = "\(self.match.start!) - \(self.match.finish!)"
        self.price.text = self.match.price
        self.vacancies.text = self.match.vacancies

        getCreator()
    }

    func getCreator() {
        MatchService.getCreator(match) { (user) in
            if let user = user {
                self.creator.text = user.name
            }
        }
    }

    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Wops", message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)

        present(alert, animated: true)
    }

    @IBAction func clickSubscribe(_ sender: UIButton) {
        SubscriptionService.create(match) { (error) in
            if let error = error {
                self.showMessage(error)
            } else {
                self.performSegue(withIdentifier: "unwindSelectMatch", sender: nil)
            }
        }
    }

}
