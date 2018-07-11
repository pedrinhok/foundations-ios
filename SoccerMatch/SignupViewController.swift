import UIKit
import CoreData

class SignupViewController: UIViewController {

    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    @IBOutlet weak var name: StandardTextField!
    @IBOutlet weak var phone: StandardTextField!
    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var password: StandardTextField!
    @IBOutlet weak var confirmPassword: StandardTextField!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        name.delegate = self
        phone.delegate = self
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate = self
        confirmPassword.delegate = self
        
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func hideKeyboard(){
        name.resignFirstResponder()
        phone.resignFirstResponder()
        email.resignFirstResponder()
        password.resignFirstResponder()
        confirmPassword.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: Notification){
        print("Keyboard will show:  \(notification.name.rawValue)")
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]as? NSValue)?.cgRectValue else{
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            
            view.frame.origin.y  = -keyboardRect.height
        }else {
            view.frame.origin.y = 0
        }
        
    }

    @IBAction func clickSignup(_ sender: StandardButton) {

        showLoading()
        hideKeyboard()
        
        guard let name = name.text, name != "" else {
            showMessage("Name cannnot be empty!")
            hideLoading()
            return
        }
        if name.count < 3 {
            showMessage("Name must be at least 6 characters!")
            hideLoading()
            return
        }
        guard let phone = phone.text, phone != "" else {
            showMessage("Phone cannnot be empty!")
            hideLoading()
            return
        }
        guard let email = email.text, email != "" else {
            showMessage("E-mail cannnot be empty!")
            hideLoading()
            return
        }
        guard let password = password.text, password != "" else {
            showMessage("Password cannnot be empty!")
            hideLoading()
            return
        }
        if password.count < 6 {
            showMessage("Password must be at least 6 characters!")
            hideLoading()
            return
        }
        guard let confirmPassword = confirmPassword.text, password == confirmPassword else {
            showMessage("Password does not match your confirmation!")
            hideLoading()
            return
        }

        UserService.create(name: name, phone: phone, email: email, password: password) { (error) in
            if let error = error {
                self.showMessage(error)
                self.hideLoading()
            } else {
                self.performSegue(withIdentifier: "gotoHome", sender: nil)
            }
        }
    }

    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Wops", message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)

        present(alert, animated: true)
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
}

extension SignupViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

}
