import UIKit

class ChangePasswordViewController: UIViewController {
    
    var user: UserO!

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
    
    func showMessage(_ message: String, title: String = "Wops") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func changePassword(_ sender: StandardButton) {
        
        guard let password = password.text, password != "" else {
            showMessage("Confirm you current password!")
            return
        }
        if password != user.password {
            showMessage("Your current password is wrong!")
            return
        }

        guard let newPassword = newPassword.text, newPassword != "" else {
            showMessage("New password cannnot be empty!")
            return
        }
        if newPassword.count < 3 {
            showMessage("New password must be at least 3 characters!")
            return
        }
        guard let confirmPassword = confirmPassword.text, newPassword == confirmPassword else{
            showMessage("Password does not match your confirmation!")
            return
        }
        if confirmPassword == newPassword{
            showMessage("Password changed!", title: "Done")
        }
  
    }

}

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}
