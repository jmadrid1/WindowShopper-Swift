
import UIKit
import Firebase
import FirebaseAuth

class CreateUserAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mFirstNameTextField: UITextField!
    @IBOutlet weak var mLastNameTextField: UITextField!
    @IBOutlet weak var mPasswordTextField: UITextField!
    @IBOutlet weak var mConfirmPasswordTextField: UITextField!
    @IBOutlet weak var mEmailTextField: UITextField!
    
    @IBOutlet weak var mMismatchedPasswordsLabel: UILabel!
    
    @IBOutlet weak var mRegisterButton: UIButton!
    
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
        
        mRegisterButton.setTitle("Register", for: .normal)
        
        mRegisterButton.layer.cornerRadius = 15
        mRegisterButton.layer.borderWidth = 2
        mRegisterButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        mRegisterButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        mRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        mRegisterButton.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        mRegisterButton.layer.cornerRadius = 15
        mRegisterButton.layer.borderWidth = 2
        mRegisterButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
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
    
    @IBAction func createAccount(){
        
        if(Connectivity.isConnectedToNetwork()){
        
            let firstName = mFirstNameTextField.text
            let lastName = mLastNameTextField.text
            
            let email = mEmailTextField.text?.lowercased()
            let password = mPasswordTextField.text
            let confirmPassword = mConfirmPasswordTextField.text
            
            if(password == confirmPassword){
            
                Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in

                    if let error = error {
                        print(error)
                        return
                    }

                    let uid = user?.uid
                    UserDefaults.standard.setValue(uid, forKey: "uid")
                    
                    let values = ["firstname": firstName!, "lastname": lastName!, "email": email!, "password": password!]
                    
                    self.mRef.child("users").child(uid!).setValue(values)
                
                    Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                        
                        if let error = error{
                            print(error)
                            return
                        }
                        
                        let uid = user?.uid
                        UserDefaults.standard.setValue(uid, forKey: "uid")
        
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            }else{
                self.mMismatchedPasswordsLabel.isHidden = false
                return
            }
        }else{
            showNoNetworkConnectionAlert()
        }
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

}
