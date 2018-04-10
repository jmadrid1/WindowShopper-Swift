
import UIKit
import Firebase
import Cosmos

class AddReviewVC: UIViewController {
    
    @IBOutlet weak var mIconImage: UIImageView!
    @IBOutlet weak var mRatingScale: CosmosView!
    @IBOutlet weak var mCommentTextField: UITextField!
    @IBOutlet weak var mSubmitReview: UIButton!
    
    var mItemId: Int?
    
    var mRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        mRef = Database.database().reference()
        
        mIconImage.frame = CGRect(x: 110, y: 156, width: 179, height: 154)
        mIconImage.image = UIImage(named: "ic_add_review.png")
        
        mRatingScale.frame = CGRect(x: 105, y: 359, width: 209, height: 37)
        mRatingScale.settings.filledColor = #colorLiteral(red: 0.849943329, green: 0.7401361611, blue: 0.239743404, alpha: 1)
        mRatingScale.settings.minTouchRating = 1
        mRatingScale.settings.starSize = 34
        mRatingScale.settings.totalStars = 5
        
        mCommentTextField.borderStyle = UITextBorderStyle.roundedRect
        
        mSubmitReview.frame = CGRect(x: 156, y: 525, width: 101, height: 30)
        mSubmitReview.setTitle("Submit Review", for: .normal)
        mSubmitReview.setTitleColor(#colorLiteral(red: 0.849943329, green: 0.7401361611, blue: 0.239743404, alpha: 1), for: .normal)
        mSubmitReview.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showNoNetworkConnectionAlert(){
        
        let alert = UIAlertController(title: "No Network Connectivity", message: "Check network connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func submitItemReview(){
        
        if(Connectivity.isConnectedToNetwork()){
        
            let id:Int = mItemId!
            let idString = String(id)
            let uid = UserDefaults.standard.string(forKey: "uid")
            let comment = mCommentTextField.text
            let rating = Int(mRatingScale.rating)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            let date = Date()
            let dateString = formatter.string(from: date)

            let values = ["id": id, "uid": uid!, "comment": comment!, "rating": rating, "date": dateString] as [String : Any]
        
            mRef.child("inventory").child(idString).child("reviews").childByAutoId().setValue(values)
            
            self.navigationController?.popViewController(animated: true)
        }else{
            showNoNetworkConnectionAlert()
        }
    }

}
