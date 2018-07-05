import UIKit
import CoreData

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate,  UITextFieldDelegate{
    
    
    @IBOutlet weak var name: StandardTextField!
    @IBOutlet weak var gender: StandardTextField!
    @IBOutlet weak var birthday: StandardTextField!
    @IBOutlet weak var phone: StandardTextField!
    @IBOutlet weak var email: StandardTextField!
    @IBOutlet weak var photo: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        //imagePicker.delegate = self 
        name.delegate = self
        gender.delegate = self
        birthday.delegate = self
        phone.delegate = self
        email.delegate = self
       
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.name{
            textField.backgroundColor = UIColor.lightGray
            return true
        }else if textField == self.gender{
            textField.backgroundColor = UIColor.lightGray
            return true
        }else if textField == self.birthday{
            textField.backgroundColor = UIColor.lightGray
            return true
        }else if textField == self.phone{
            textField.backgroundColor = UIColor.lightGray
            return true
        }else if textField == self.email{
            textField.backgroundColor = UIColor.lightGray
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.name{
  
        }else if textField == self.gender{

        }else if textField == self.birthday{

        }else if textField == self.phone{

        }else if textField == self.email{

        }
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
    
    @IBAction func clickSubmit(_ sender: StandardButton) {
        
        
    }
    
    
    
}

