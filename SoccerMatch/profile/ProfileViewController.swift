import UIKit

class ProfileViewController: UIViewController {
    
    @IBAction func logout(_ sender: UIButton) {
        UserService.logout { bool in
            if bool! {
                self.performSegue(withIdentifier: "unwindSignin", sender: nil)
            } else {
                self.showMessage("Api is off")
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
