import UIKit
import CoreData

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    var user: User!

    @IBOutlet weak var name: StandardTextField!
    @IBOutlet weak var gender: StandardTextField!
    @IBOutlet weak var birthday: StandardTextField!
    @IBOutlet weak var phone: StandardTextField!
    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var photo: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        imagePicker.delegate = self
        name.delegate = self
        gender.delegate = self
        birthday.delegate = self
        phone.delegate = self
        email.delegate = self
        
        getUser()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "gotoChangePassword":
            guard let vc = segue.destination as? ChangePasswordViewController else { return }
            vc.user = user
            return
            
        case .none, .some(_):
            return
        }
    }

    func getUser() {
        // request user to firebase
        user = User(name: "User 1", birthday: "01/01/2000", gender: "Female", phone: "123", email: "user1@email.com", password: "password")
        name.text = user.name
        gender.text = user.gender
        birthday.text = user.birthday
        phone.text = user.phone
        email.text = user.email
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.name{
            textField.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
            return true
        }else if textField == self.gender{
            textField.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
            return true
        }else if textField == self.birthday{
            textField.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
            return true
        }else if textField == self.phone{
            textField.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
            return true
        }else if textField == self.email{
            textField.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }

    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.name{
            textField.backgroundColor = UIColor.white
            return true
        }else if textField == self.gender{
            textField.backgroundColor = UIColor.white
            return true
        }else if textField == self.birthday{
            textField.backgroundColor = UIColor.white
            return true
        }else if textField == self.phone{
            textField.backgroundColor = UIColor.white
            return true
        }else if textField == self.email{
            textField.backgroundColor = UIColor.white
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.name{
            self.name = textField as! StandardTextField
        }else if textField == self.gender{
            self.gender = textField as! StandardTextField
        }else if textField == self.birthday{
            self.birthday = textField as! StandardTextField
        }else if textField == self.phone{
            self.phone = textField as! StandardTextField
        }else if textField == self.email{
            self.email = textField as! StandardTextField
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func password(_ sender: UIButton) {
         performSegue(withIdentifier: "gotoChangePassword", sender: nil)
    }
    
    @IBAction func changePhoto(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            photo.image = image
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSubmit(_ sender: StandardButton) {
        user.name = self.name.text
        user.gender = self.gender.text
        user.birthday = self.birthday.text
        user.phone = self.phone.text
        user.email = self.email.text
    }
    
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

struct User {
    var name: String?
    var birthday: String?
    var gender: String?
    var phone: String?
    var email: String?
    var password: String?
}
