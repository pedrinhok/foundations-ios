import UIKit

class SelectMatchViewController: UIViewController {

    var match: Match!

    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var location: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        desc.text = match.desc
        location.text = match.location
    }

}
