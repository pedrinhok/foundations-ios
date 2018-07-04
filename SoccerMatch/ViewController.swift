import UIKit
import CoreData

import MapKit

class ViewController: UIViewController {

    var locationManager = CLLocationManager()

    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var password: StandardTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func clickSignin(_ sender: StandardButton) {
        locationManager.requestWhenInUseAuthorization()
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
