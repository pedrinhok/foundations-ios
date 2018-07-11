import UIKit
import CoreData

import MapKit

class ViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var password: StandardTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        email.delegate = self
        password.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showLoading()
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        hideLoading()
        
        if UserService.auth() {
            performSegue(withIdentifier: "gotoHome", sender: nil)
        }
    }
    
    @IBAction func unwindSignin(segue: UIStoryboardSegue) {}
    
    @IBAction func clickSignin(_ sender: StandardButton) {
        showLoading()
        
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
        
        UserService.signin(email: email, password: password) { (error) in
            if error != nil {
                self.hideLoading()
                self.showMessage("User not found!")
            } else {
                self.locationManager.requestWhenInUseAuthorization()
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
        viewLoading.isUserInteractionEnabled = false
        activityLoading.startAnimating()
    }
    
    func hideLoading() {
        viewLoading.isHidden = true
        viewLoading.isUserInteractionEnabled = true
        activityLoading.stopAnimating()
    }
    
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
        default:
            print("unauthorized")
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}
