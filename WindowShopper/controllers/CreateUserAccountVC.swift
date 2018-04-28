
import UIKit
import Firebase
import FirebaseAuth

class CreateUserAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mFirstNameTextField: UITextField!
    @IBOutlet weak var mLastNameTextField: UITextField!
    @IBOutlet weak var mPasswordTextField: UITextField!
    @IBOutlet weak var mConfirmPasswordTextField: UITextField!
    @IBOutlet weak var mEmailTextField: UITextField!
    
    @IBOutlet weak var mFirstNameLabel: UILabel!
    @IBOutlet weak var mLastNameLabel: UILabel!
    @IBOutlet weak var mEmailLabel: UILabel!
    @IBOutlet weak var mPasswordLabel: UILabel!
    @IBOutlet weak var mConfirmPasswordLabel: UILabel!
    
    @IBOutlet weak var mMismatchedPasswordsLabel: UILabel!
    
    @IBOutlet weak var mRegisterButton: UIButton!
    
    var mRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mRef = Database.database().reference()
        
        mFirstNameLabel.text = "First Name:"
        mLastNameLabel.text = "Last Name:"
        mEmailLabel.text = "Email:"
        mPasswordLabel.text = "Password:"
        mConfirmPasswordLabel.text = "Confirm Password:"
        
        mFirstNameLabel.font = UIFont.systemFont(ofSize: 14)
        mLastNameLabel.font = UIFont.systemFont(ofSize: 14)
        mEmailLabel.font = UIFont.systemFont(ofSize: 14)
        mPasswordLabel.font = UIFont.systemFont(ofSize: 14)
        mConfirmPasswordLabel.font = UIFont.systemFont(ofSize: 14)
        
        mFirstNameLabel.frame = CGRect(x: 118, y: 229, width: 74, height: 17)
        mLastNameLabel.frame = CGRect(x: 118, y: 277, width: 73, height: 17)
        mEmailLabel.frame = CGRect(x: 150, y: 328, width: 39, height: 17)
        mPasswordLabel.frame = CGRect(x: 125, y: 384, width: 67, height: 17)
        mConfirmPasswordTextField.frame = CGRect(x: 70, y: 431, width: 122, height: 17)
        
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
        
        mFirstNameTextField.frame = CGRect(x: 200, y: 222, width: 154, height: 30)
        mLastNameTextField.frame = CGRect(x: 200, y: 271, width: 154, height: 30)
        mEmailTextField.frame = CGRect(x: 200, y: 322, width: 169, height: 30)
        mPasswordTextField.frame = CGRect(x: 200, y: 377, width: 145, height: 30)
        mConfirmPasswordTextField.frame = CGRect(x: 200, y: 424, width: 145, height: 30)
        
        mFirstNameTextField.autocapitalizationType = .words
        mLastNameTextField.autocapitalizationType = .words

        mEmailTextField.keyboardType = UIKeyboardType.emailAddress
        
        mPasswordTextField.isSecureTextEntry = true
        mConfirmPasswordTextField.isSecureTextEntry = true
        
        mRegisterButton.setTitle("Register", for: .normal)
        mRegisterButton.setTitleColor(#colorLiteral(red: 0.849943329, green: 0.7401361611, blue: 0.239743404, alpha: 1), for: .normal)
        mRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        mRegisterButton.frame = CGRect(x: 179, y: 616, width: 57, height: 30)
        
        mMismatchedPasswordsLabel.text = "*Passwords do not match"
        mMismatchedPasswordsLabel.frame = CGRect(x: 96, y: 558, width: 222, height: 21)
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
