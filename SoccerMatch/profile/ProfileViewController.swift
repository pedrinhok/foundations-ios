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
    @IBOutlet var genderKeyboard: UIView!
    @IBOutlet var birthKeyboard: UIView!
    @IBOutlet weak var genderSelector: UIPickerView!
    @IBOutlet weak var birthSelector: UIDatePicker!
    
    let genders = ["Masculino", "Feminino", "Outro"]
    let imagePicker = UIImagePickerController()
    let user = UserService.current()!
    
    override func viewDidLoad() {
        imagePicker.delegate = self
        
        name.delegate = self
        name.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        
        gender.delegate = self
        gender.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        gender.inputView = genderKeyboard
        
        birthday.delegate = self
        birthday.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        birthday.inputView = birthKeyboard
        
        phone.delegate = self
        phone.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        
        email.delegate = self
        email.addTarget(self, action:#selector(ProfileViewController.textFieldDataChanged), for:UIControlEvents.editingChanged)
        
        var sevenDaysfromNow: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .day, value: 7, to: Date(), options: [])!
        }
        birthSelector.maximumDate = sevenDaysfromNow
        genderSelector.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        submitBtn.disable()

        // Atualiza datePicker
        if let birthday = user.birthday {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let date = formatter.date(from: birthday)
            if let date = date {
                birthSelector.date = date
            }
        }

        getUser()
    }

    func getUser() {
        name.text = user.name
        gender.text = user.gender
        birthday.text = user.birthday
        phone.text = user.phone
        email.text = user.email
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
            self.showMessage("Profile updated", title: "Success")
        }
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
    
    @IBAction func unwindProfile(segue: UIStoryboardSegue) {}
    
    func showMessage(_ message: String, title: String? = nil){
        
        var alert: UIAlertController
        
        if let title = title {
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Wops", message: message, preferredStyle: .alert)
        }
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @IBAction func genderUpdate(_ sender: UIButton) {
        
        gender.text = genders[genderSelector.selectedRow(inComponent: 0)]
        gender.resignFirstResponder()
        enableButton()
    }
    
    @IBAction func birthUpdate(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birthday.text = formatter.string(from: birthSelector.date)
        birthday.resignFirstResponder()
        enableButton()
    }
    
    func enableButton() {
        if user.gender == gender.text
            && user.email == email.text
            && user.birthday == birthday.text
            && user.email == email.text
            && user.phone == phone.text
            && user.name == name.text {
            submitBtn.disable()
        } else {
            submitBtn.enable()
        }
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
        enableButton()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
        return true

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = UIColor.white
        return true
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

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
}

