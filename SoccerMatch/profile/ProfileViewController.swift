import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var name: StandardTextField!
    @IBOutlet weak var gender: StandardTextField!
    @IBOutlet weak var birthday: StandardTextField!
    @IBOutlet weak var phone: StandardTextField!
    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var submitBtn: StandardButton!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        imagePicker.delegate = self
        
        name.delegate = self
        name.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        
        gender.delegate = self
        gender.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        
        birthday.delegate = self
        birthday.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        
        phone.delegate = self
        phone.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        
        email.delegate = self
        email.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        submitBtn.disable()
        getUser()
    }

    func getUser() {
        if let user = UserService.current() {
            name.text = user.name
            gender.text = user.gender
            birthday.text = user.birthday
            phone.text = user.phone
            email.text = user.email
        }
    }

    @IBAction func password(_ sender: UIButton) {
         performSegue(withIdentifier: "gotoChangePassword", sender: nil)
    }
    
    @IBAction func changePhoto(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @IBAction func clickSubmit(_ sender: StandardButton) {
        
        var user = User()
        user.name = self.name.text
        user.gender = self.gender.text
        user.birthday = self.birthday.text
        user.phone = self.phone.text
        user.email = self.email.text
        
        UserService.updateUserData(data: user) { (error) in
            if let error = error {
                self.showMessage(error)
                return
            }
            self.submitBtn.disable()
            self.name.resignFirstResponder()
            self.gender.resignFirstResponder()
            self.birthday.resignFirstResponder()
            self.phone.resignFirstResponder()
            self.email.resignFirstResponder()
        }
    }

    @IBAction func logout(_ sender: UIButton) {
        UserService.signout() {
            self.performSegue(withIdentifier: "unwindSignin", sender: nil)
        }
    }

    @IBAction func unwindProfile(segue: UIStoryboardSegue) {}
    
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Wops", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            photo.image = image
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    
    @objc func textFieldDataChanged() {
        submitBtn.enable()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
        return true

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = UIColor.white
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.name = textField as! StandardTextField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "gotoChangePassword":
            //            performSegue(withIdentifier: "gotoChangePassword", sender: nil)
            return
        case .none, .some(_):
            return
        }
    }
    
}

