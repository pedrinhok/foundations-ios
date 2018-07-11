import UIKit
import CoreData

import MapKit

class ViewController: UIViewController {

    var locationManager = CLLocationManager()

    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var password: StandardTextField!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        locationManager.delegate = self
        email.delegate = self
        password.delegate = self

        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserService.auth() {
            performSegue(withIdentifier: "gotoHome", sender: nil)
        }
    }

    @IBAction func unwindSignin(segue: UIStoryboardSegue) {}

    @IBAction func clickSignin(_ sender: StandardButton) {

        guard let email = email.text, email != "" else {
            showMessage("E-mail cannnot be empty!")
            return
        }

        guard let password = password.text, password != "" else {
            showMessage("Password cannnot be empty!")
            return
        }

        UserService.signin(email: email, password: password) { (error) in
            if error != nil {
                self.showMessage("User not found!")
            } else {
                self.locationManager.requestWhenInUseAuthorization()
                self.performSegue(withIdentifier: "gotoHome", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        email.delegate = self
        password.delegate = self
        
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
        email.resignFirstResponder()
        password.resignFirstResponder()
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
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            print("Return pressed")
//            hideKeyboard()
//            return true
//
//    }

    
    

    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Wops", message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)

        present(alert, animated: true)
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
