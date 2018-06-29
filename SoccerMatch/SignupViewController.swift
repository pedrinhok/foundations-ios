import UIKit
import CoreData

class SignupViewController: UIViewController {

    @IBOutlet weak var name: StandardTextField!
    @IBOutlet weak var phone: StandardTextField!
    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var password: StandardTextField!
    @IBOutlet weak var confirmPassword: StandardTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        name.delegate = self
        phone.delegate = self
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
    }

    @IBAction func clickSignup(_ sender: StandardButton) {

        guard let name = name.text, name != "" else {
            showMessage("Name cannnot be empty!")
            return
        }
        if name.count < 3 {
            showMessage("Name must be at least 3 characters!")
            return
        }
        guard let phone = phone.text, phone != "" else {
            showMessage("Phone cannnot be empty!")
            return
        }
        guard let email = email.text, email != "" else {
            showMessage("E-mail cannnot be empty!")
            return
        }
        guard let password = password.text, password != "" else {
            showMessage("Password cannnot be empty!")
            return
        }
        if password.count < 3 {
            showMessage("Password must be at least 3 characters!")
            return
        }
        guard let confirmPassword = confirmPassword.text, password == confirmPassword else {
            showMessage("Password does not match your confirmation!")
            return
        }

        UserService.create(name: name, phone: phone, email: email, password: password)

        performSegue(withIdentifier: "gotoHome", sender: nil)
    }

    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Wops", message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)

        present(alert, animated: true)
    }

}

extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}
