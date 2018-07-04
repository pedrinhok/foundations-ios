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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        locationManager.requestWhenInUseAuthorization()

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
            if let error = error {
                self.showMessage(error)
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
