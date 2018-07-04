import UIKit

class ScheduleViewController: UIViewController {

    @IBAction func clickUpdate(_ sender: StandardButton) {
        performSegue(withIdentifier: "unwindNewMatch", sender: nil)
    }

}
