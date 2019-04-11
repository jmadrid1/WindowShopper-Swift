
import UIKit
import Firebase

class ItemReviewsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mAddBarItem: UIBarButtonItem!
    
    @IBOutlet weak var mReviewsTable: UITableView!
    @IBOutlet weak var mAddBarButton: UIBarButtonItem!
    
    var mSelectedItem: Clothes?
    var mReviewsList = [Review]()
    
    var mRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mRef = Database.database().reference()
    
        mReviewsTable.rowHeight = 85
        
        let uid = UserDefaults.standard.string(forKey: "uid")
        
        if(uid == nil){
            self.navigationItem.rightBarButtonItem = nil
        }else{
            self.navigationItem.rightBarButtonItem = mAddBarItem
        }
        
        let id:Int = (mSelectedItem?.id)!
        getReviewsForItemByDate(id: id)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showNoNetworkConnectionAlert(){
        
        let alert = UIAlertController(title: "No Network Connectivity", message: "Check network connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
        
    func getReviewsForItemByDate(id: Int) {
        
        if(Connectivity.isConnectedToNetwork()){
            
            let itemId = String(id)
            mRef.child("inventory").child(itemId).child("reviews").queryOrdered(byChild: "date").observe(.value) { (snapshot) in
                
                for review in snapshot.children.allObjects as! [DataSnapshot]{
                    
                    let reviewDict = review.value as? [String: AnyObject]
                    let id = reviewDict?["id"] as! Int
                    let comment = reviewDict?["comment"] as! String
                    let rating = reviewDict?["rating"] as! Int
                    let date = reviewDict?["date"] as! String
 
                    let review = Review(id: id, comment: comment, rating: rating, date: date)

                    self.mReviewsList.append(review)

                    self.mReviewsTable.reloadData()
                }
            }
        }else{
           showNoNetworkConnectionAlert()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mReviewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReviewCell = mReviewsTable.dequeueReusableCell(withIdentifier: "reviewCell") as! ReviewCell
        
        let review = mReviewsList[indexPath.row]

        cell.mCommentTextView.text = review.comment
        cell.mDateLabel.text = review.date
        
        cell.mRatingScale.rating = Double(review.rating)
        
        return cell
    }
}
