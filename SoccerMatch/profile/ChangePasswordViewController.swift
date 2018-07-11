import UIKit

class ChangePasswordViewController: UIViewController {

    var user: ManagedUser!

    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
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
        
        changePassBtn.inactive()
        
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
        
        hideKeyboard()
        showLoading()
        changePassBtn.inactive()
        
        guard let password = password.text, password != "" else {
            showMessage("Confirm you current password!")
            hideLoading()
            return
        }
        
        guard let newPassword = newPassword.text, newPassword != "" else {
            showMessage("New password cannnot be empty!")
            hideLoading()
            return
        }
        
        if newPassword.count < 6 {
            showMessage("New password must be at least 6 characters!")
            hideLoading()
            return
        }
        
        guard let confirmPassword = confirmPassword.text, newPassword == confirmPassword else {
            showMessage("Password does not match your confirmation!")
            hideLoading()
            return
        }
        
        UserService.changePassword(oldPassword: password, newPassword: newPassword) { (error) in
            if let error = error {
                self.showMessage(error)
                self.hideLoading()
                return
            }
            self.showMessage("Password changed!", title: "Done") {
                self.performSegue(withIdentifier: "unwindProfile", sender: nil)
                self.hideLoading()
            }
        }
    }
    
    @objc func textFieldDataChanged() {
        changePassBtn.active()
    }
    
    func showLoading() {
        viewLoading.isHidden = false
        viewLoading.isUserInteractionEnabled = true
        activityLoading.startAnimating()
    }
    
    func hideLoading() {
        viewLoading.isHidden = true
        viewLoading.isUserInteractionEnabled = false
        activityLoading.stopAnimating()
    }
    
    func hideKeyboard() {
        password.resignFirstResponder()
        newPassword.resignFirstResponder()
        confirmPassword.resignFirstResponder()
    }

}

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}
