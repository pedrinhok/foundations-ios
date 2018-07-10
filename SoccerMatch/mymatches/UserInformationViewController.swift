import UIKit

class UserInformationViewController: UIViewController {

    var match: Match!
    var user: User!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var numberCreated: UILabel!
    @IBOutlet weak var numberSubscriptions: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        name.text = user.name
        phone.text = user.phone

        getMatches()
    }

    func getMatches() {
        MatchService.get(creator: user.ref) { (matches) in
            self.numberCreated.text = String(matches.count)
        }
        SubscriptionService.getMatches(user: user.ref) { (matches) in
            self.numberSubscriptions.text = String(matches.count)
        }
    }

}
