import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var password: StandardTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        email.delegate = self
        password.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserService.auth() {
            performSegue(withIdentifier: "gotoHome", sender: nil)
        }
    }

    @IBAction func clickSignin(_ sender: StandardButton) {}

}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

}
