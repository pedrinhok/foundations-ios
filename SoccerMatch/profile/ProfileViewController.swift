import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    @IBOutlet weak var name: StandardTextField!
    @IBOutlet weak var gender: StandardTextField!
    @IBOutlet weak var birthday: StandardTextField!
    @IBOutlet weak var phone: StandardTextField!
    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var photo: CircleImage!
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
        
        var daysfromNow: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .day, value: 0, to: Date(), options: [])!
        }
        birthSelector.maximumDate = daysfromNow
        genderSelector.delegate = self
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        photo.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
        enableButton()
    }

    func getUser() {
        name.text = user.name
        gender.text = user.gender
        birthday.text = user.birthday
        phone.text = user.phone
        email.text = user.email
        if let userPhoto = user.photo, photo.image == #imageLiteral(resourceName: "icon-user") {
            photo.image = UIImage(data: userPhoto, scale: 1.0)
        }
    }

    @IBAction func password(_ sender: UIButton) {
         performSegue(withIdentifier: "gotoChangePassword", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFullscreenPhoto" {
            let destination = segue.destination as! FullScreenPhotoViewController
            destination.photoFull = photo.image!
        }
    }
    
    @IBAction func clickSubmit(_ sender: StandardButton) {
        
        showLoading()
        
        var userObj = User()
        userObj.name = self.name.text
        userObj.gender = self.gender.text
        userObj.birthday = self.birthday.text
        userObj.phone = self.phone.text
        userObj.email = self.email.text
        
        if photo.image! != #imageLiteral(resourceName: "icon-user") && UIImagePNGRepresentation(photo.image!) != user.photo {
            userObj.photo = UIImagePNGRepresentation(photo.image!)
        }
        
        submitBtn.disable()
        UserService.updateUserData(data: userObj) { (error) in
            if let error = error {
                self.showMessage(error)
                self.enableButton()
                self.hideLoading()
                return
            }
            self.name.resignFirstResponder()
            self.gender.resignFirstResponder()
            self.birthday.resignFirstResponder()
            self.phone.resignFirstResponder()
            self.email.resignFirstResponder()
            
            self.showMessage("Profile updated", title: "Success")
            self.hideLoading()
        }
    }

    @IBAction func logout(_ sender: UIButton) {
        UserService.signout() {
            self.performSegue(withIdentifier: "unwindSignin", sender: nil)
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
                && user.name == name.text
                && user.photo == UIImagePNGRepresentation(photo.image!) {
            submitBtn.disable()
        } else {
            submitBtn.enable()
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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

extension ProfileViewController: UIImagePickerControllerDelegate {
    
    @IBAction func changePhoto(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo.image = resizeImage(image: image, targetSize: CGSize(width: 200.0, height: 200.0))
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "goToFullscreenPhoto", sender: sender)
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

