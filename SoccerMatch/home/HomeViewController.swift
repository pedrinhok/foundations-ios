import UIKit
import CoreData

class HomeViewController: UIViewController {

    var user: ManagedUser!

    override func viewDidLoad() {
        super.viewDidLoad()

        user = UserService.current()!
    }

    @IBAction func clickNewMatch(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoNewMatch", sender: nil)
    }

}
