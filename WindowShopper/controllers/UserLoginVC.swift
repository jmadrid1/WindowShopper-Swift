
import UIKit
import FirebaseAuth

class UserLoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mLogoImage: UIImageView!
    
    @IBOutlet weak var mEmailLabel: UILabel!
    @IBOutlet weak var mPasswordLabel: UILabel!
    
    @IBOutlet weak var mEmailTextField: UITextField!
    @IBOutlet weak var mPasswordTextField: UITextField!
    
    @IBOutlet weak var mIncorrectPasswordLabel: UILabel!
    
    @IBOutlet weak var mLoginButton: UIButton!
    @IBOutlet weak var mCreateAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mLogoImage.image =  UIImage(named: "ic_windowshopper_transparent.png")
        mLogoImage.frame = CGRect(x: 155, y: 174, width: 133, height: 128)
        
        mEmailLabel.text = "Email:"
        mPasswordLabel.text = "Password:"
        
        mEmailTextField.tag = 0
        mPasswordTextField.tag = 1
        
        mEmailTextField.frame = CGRect(x: 120, y: 324, width: 223, height: 30)
        mPasswordTextField.frame = CGRect(x: 120, y: 370, width: 223, height: 30)
        
        mEmailTextField.keyboardType = UIKeyboardType.emailAddress
        mPasswordTextField.isSecureTextEntry = true
        
        mLoginButton.setTitle("Login", for: .normal)
        mLoginButton.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        mLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        mLoginButton.frame = CGRect(x: 196, y: 417, width: 49, height: 30)
        
        mIncorrectPasswordLabel.text = "*Email and/or password do not match any accounts"
        mIncorrectPasswordLabel.textColor = UIColor.red
        mIncorrectPasswordLabel.font = UIFont.systemFont(ofSize: 15)
        mIncorrectPasswordLabel.frame = CGRect(x: 20, y: 455, width: 385, height: 21)
        mIncorrectPasswordLabel.isHidden = true
        
        mCreateAccountButton.setTitle("Create An Account", for: .normal)
        mCreateAccountButton.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        mCreateAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        mCreateAccountButton.frame = CGRect(x: 143, y: 642, width: 143, height: 30)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showNoNetworkConnectionAlert(){
        
        let alert = UIAlertController(title: "No Network Connectivity", message: "Check network connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signIn(){
        
        if(Connectivity.isConnectedToNetwork()){
        
            let email = mEmailTextField.text?.lowercased()
            let password = mPasswordTextField.text
            
            Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                
                if let error = error{
                    print(error)
                    self.mIncorrectPasswordLabel.isHidden = false
                    return
                }
                
                self.mIncorrectPasswordLabel.isHidden = true
                
                let uid = user?.uid
                UserDefaults.standard.setValue(uid, forKey: "uid")

                self.tabBarController?.selectedIndex = 0;
            }
        }else{
            showNoNetworkConnectionAlert()
        }
    }
    
    @IBAction func createAccount(){
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UIViewController = storyboard.instantiateViewController(withIdentifier: "createAccountVC") as UIViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
            
        case 0:
            mEmailTextField.resignFirstResponder()
            return true
            
        case 1:
            mPasswordTextField.resignFirstResponder()
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
            return newLength <= 45
            
        case 1:
            return newLength <= 25
            
        default:
            return newLength <= 35
        }
    }

}
