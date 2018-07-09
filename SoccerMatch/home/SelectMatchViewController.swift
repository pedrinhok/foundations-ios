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

        desc.text = match.desc
        location.text = match.location
        day.text = match.day
        schedule.text = "\(match.start!) - \(match.finish!)"
        price.text = match.price
        vacancies.text = match.vacancies

        getCreator()
    }

    func getCreator() {
        MatchService.getCreator(match) { (user) in
            if let user = user {
                self.creator.text = user.name
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
                self.showMessage(title: "You have successfully subscribed to this match", message: "The creator of the match must still accept you") {
                    self.performSegue(withIdentifier: "unwindSelectMatch", sender: nil)
                }
            }
        }
    }

}
