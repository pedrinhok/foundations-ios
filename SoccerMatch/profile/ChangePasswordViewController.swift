import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var password: StandardTextField!
    @IBOutlet weak var newPassword: StandardTextField!
    @IBOutlet weak var confirmPassword: StandardTextField!
    
    override func viewDidLoad() {
        password.delegate = self
        newPassword.delegate = self
        confirmPassword.delegate = self
        
        password.isSecureTextEntry = true
        newPassword.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
    }
    
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Wops", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showMessageNewPassword(_ message: String) {
        let alert = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func changePassword(_ sender: StandardButton) {
        
        guard let newPassword = newPassword.text, newPassword != "" else {
            showMessage("Password cannnot be empty!")
            return
        }
        if newPassword.count < 3 {
            showMessage("Password must be at least 3 characters!")
            return
        }
        guard let confirmPassword = confirmPassword.text, newPassword == confirmPassword else{
            showMessage("Password does not match your confirmation!")
            return
        }
        if confirmPassword == newPassword{
            showMessageNewPassword("Password changed!")
        }
  
    }

}
