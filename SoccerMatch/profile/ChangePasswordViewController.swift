import UIKit

class ChangePasswordViewController: UIViewController {

    var user: ManagedUser!

    @IBOutlet weak var password: StandardTextField!
    @IBOutlet weak var newPassword: StandardTextField!
    @IBOutlet weak var confirmPassword: StandardTextField!
    @IBOutlet weak var changePassBtn: StandardButton!
    
    override func viewDidLoad() {
        password.delegate = self
        newPassword.delegate = self
        confirmPassword.delegate = self
        
        password.isSecureTextEntry = true
        newPassword.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
        
        changePassBtn.disable()
        
        password.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        newPassword.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        confirmPassword.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        
        user = UserService.current()!
    }
    
    func showMessage(_ message: String, title: String = "Wops", completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
            if let completion = completion { completion() }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func changePassword(_ sender: StandardButton) {
        
        changePassBtn.disable()
        
        guard let password = password.text, password != "" else {
            showMessage("Confirm you current password!")
            return
        }
        
        guard let newPassword = newPassword.text, newPassword != "" else {
            showMessage("New password cannnot be empty!")
            return
        }
        
        if newPassword.count < 6 {
            showMessage("New password must be at least 6 characters!")
            return
        }
        
        guard let confirmPassword = confirmPassword.text, newPassword == confirmPassword else {
            showMessage("Password does not match your confirmation!")
            return
        }
        
        UserService.signin(email: user.email!, password: password) { (error) in
            if let error = error {
                self.showMessage(error)
                return
            }
            
            UserService.changePassword(password: newPassword) { (error) in
                if let error = error {
                    self.showMessage(error)
                    return
                }
                self.showMessage("Password changed!", title: "Done") {
                    self.performSegue(withIdentifier: "unwindProfile", sender: nil)
                }
            }
        }
    }
    
    @objc func textFieldDataChanged() {
        changePassBtn.enable()
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}
