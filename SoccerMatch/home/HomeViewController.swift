import UIKit
import CoreData

class HomeViewController: UIViewController {

    var user: ManagedUser!

    override func viewDidLoad() {
        super.viewDidLoad()

        user = UserService.current()!
    }

}
