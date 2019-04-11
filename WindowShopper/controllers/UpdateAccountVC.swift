
import UIKit
import Firebase

class UpdateAccountVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mFirstNameTextField: UITextField!
    @IBOutlet weak var mLastNameTextField: UITextField!
    @IBOutlet weak var mPasswordTextField: UITextField!
    @IBOutlet weak var mConfirmPasswordTextField: UITextField!
    @IBOutlet weak var mEmailTextField: UITextField!
    
    @IBOutlet weak var mMismatchedPasswordsLabel: UILabel!
    
    @IBOutlet weak var mSaveButton: UIButton!
        
    var mRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mRef = Database.database().reference()
        
        mFirstNameTextField.tag = 0
        mLastNameTextField.tag = 1
        mEmailTextField.tag = 2
        mPasswordTextField.tag = 3
        mConfirmPasswordTextField.tag = 4
        
        mFirstNameTextField.placeholder = "Enter First Name"
        mLastNameTextField.placeholder = "Enter Last Name"
        mEmailTextField.placeholder = "Enter Email"
        mPasswordTextField.placeholder = "Enter Password"
        mConfirmPasswordTextField.placeholder = "Confirm Password"
        
        mFirstNameTextField.autocapitalizationType = .words
        mLastNameTextField.autocapitalizationType = .words
        
        mEmailTextField.keyboardType = UIKeyboardType.emailAddress
        
        mPasswordTextField.isSecureTextEntry = true
        mConfirmPasswordTextField.isSecureTextEntry = true
        
        mSaveButton.setTitle("Save Changes", for: .normal)
        mSaveButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        mSaveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        mSaveButton.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        mSaveButton.layer.cornerRadius = 15
        mSaveButton.layer.borderWidth = 2
        mSaveButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        mMismatchedPasswordsLabel.text = "*Passwords do not match"
        mMismatchedPasswordsLabel.textColor = UIColor.red
        mMismatchedPasswordsLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showNoNetworkConnectionAlert(){
        
        let alert = UIAlertController(title: "No Network Connectivity", message: "Check network connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
            
        case 0:
            mFirstNameTextField.resignFirstResponder()
            return true
            
        case 1:
            mLastNameTextField.resignFirstResponder()
            return true
            
        case 2:
            mEmailTextField.resignFirstResponder()
            return true
            
        case 3:
            mPasswordTextField.resignFirstResponder()
            return true
            
        case 4:
            mConfirmPasswordTextField.resignFirstResponder()
            return true
            
        default:
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        switch textField.tag {
            
        case 0:
            return newLength <= 25
            
        case 1:
            return newLength <= 25
            
        case 2:
            return newLength <= 45
            
        case 3:
            return newLength <= 25
        
        case 4:
            return newLength <= 25
            
        default:
            return newLength <= 35
        }
    }
    
    @IBAction func updateAccount(){
        
        if(Connectivity.isConnectedToNetwork()){
        
            let uid = UserDefaults.standard.string(forKey: "uid")
            
            let firstName = mFirstNameTextField.text
            let lastName = mLastNameTextField.text
            let email = mEmailTextField.text?.lowercased()
            let password = mPasswordTextField.text
            let confirmPassword = mConfirmPasswordTextField.text
            
            if(password == confirmPassword){
                let values = ["firstname": firstName!, "lastname": lastName!, "email": email!, "password": password!]
           
                mRef.child("users").child(uid!).updateChildValues(values)
            }else{
                self.mMismatchedPasswordsLabel.isHidden = false
            }
        }else{
            showNoNetworkConnectionAlert()
        }
    }

}
