import UIKit

class NewMatchViewController: UIViewController {

    @IBOutlet weak var matchType: StandardTextField!
    @IBOutlet weak var vacancies: StandardTextField!
    @IBOutlet weak var price: StandardTextField!
    @IBOutlet weak var desc: StandardTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        matchType.delegate = self
        vacancies.delegate = self
        price.delegate = self
        desc.delegate = self
    }

    @IBAction func unwindNewMatch(segue: UIStoryboardSegue) {}

    @IBAction func clickLocation(_ sender: StandardButton) {
        performSegue(withIdentifier: "gotoLocation", sender: nil)
    }

    @IBAction func clickSchedule(_ sender: StandardButton) {
        performSegue(withIdentifier: "gotoSchedule", sender: nil)
    }

}

extension NewMatchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

}
