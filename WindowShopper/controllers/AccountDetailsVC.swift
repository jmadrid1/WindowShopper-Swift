
import UIKit
import Firebase
import FirebaseAuth

class AccountDetailsVC: UIViewController {

    @IBOutlet weak var mBannerView: UIView!
    @IBOutlet weak var mBannerIconImage: UIImageView!
    
    @IBOutlet weak var mFullNameLabel: UILabel!
    @IBOutlet weak var mEmailLabel: UILabel!
    
    @IBOutlet weak var mUpdateAccountButton: UIButton!
    @IBOutlet weak var mSignOutButton: UIButton!
    
    var mRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mRef = Database.database().reference()
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        
        mBannerView.backgroundColor = #colorLiteral(red: 0.849943329, green: 0.7401361611, blue: 0.239743404, alpha: 1)
        mBannerIconImage.image = UIImage(named: "ic_account.png")
        mBannerIconImage.frame = CGRect(x: 88, y: 134, width: 238, height: 236)
        
        mFullNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        mFullNameLabel.frame = CGRect(x: 137, y: 377, width: 147, height: 21)
        
        mEmailLabel.font = mEmailLabel.font.withSize(17)
        mEmailLabel.textColor = UIColor.lightGray
        mEmailLabel.frame = CGRect(x: 152, y: 404, width: 108, height: 21)
        
        mUpdateAccountButton.setTitle("Update Account Information", for: .normal)
        mUpdateAccountButton.setTitleColor(#colorLiteral(red: 0.849943329, green: 0.7401361611, blue: 0.239743404, alpha: 1), for: .normal
        )
        mUpdateAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        mUpdateAccountButton.frame = CGRect(x: 113, y: 483, width: 194, height: 30)
        
        mSignOutButton.setTitle("Sign Out", for: .normal)
        mSignOutButton.setTitleColor(#colorLiteral(red: 0.849943329, green: 0.7401361611, blue: 0.239743404, alpha: 1), for: .normal)
        mSignOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        mSignOutButton.frame = CGRect(x: 171, y: 519, width: 72, height: 30)
        
        checkIfUserIsLoggedIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showNoNetworkConnectionAlert(){
        
        let alert = UIAlertController(title: "No Network Connectivity", message: "Check network connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn(){
        
        let uid = UserDefaults.standard.string(forKey: "uid")
        
        if(uid == nil){
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "userLoginVC")
            
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            getAccountDetails(uid: uid!)
        }
    }
    
    func getAccountDetails(uid: String){
        
        mRef.child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            
            guard let user = snapshot.value as? [String:Any] else {
                return
            }
            
            let firstName = user["firstname"] as? String
            let lastName = user["lastname"] as? String
            
            let email = user["email"] as? String
            
            self.mFullNameLabel.text = firstName! + " " + lastName!
            self.mFullNameLabel.sizeToFit()
            
            self.mEmailLabel.text = email!
            self.mEmailLabel.sizeToFit()
        })
    }
    
    @IBAction func signOut(){
        
        if(Connectivity.isConnectedToNetwork()){
        
        UserDefaults.standard.removeObject(forKey: "uid")
        
        try! Auth.auth().signOut()
        
        self.tabBarController?.selectedIndex = 0
        }else{
            showNoNetworkConnectionAlert()
        }
    }

}
