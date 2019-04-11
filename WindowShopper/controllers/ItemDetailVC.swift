
import UIKit
import Firebase
import Kingfisher

class ItemDetailVC: UIViewController {

    @IBOutlet weak var mClothesImage: UIImageView!
    
    @IBOutlet weak var mPriceView: UIView!
    @IBOutlet weak var mPriceLabel: UILabel!
    
    @IBOutlet weak var mItemTitle: UILabel!
    @IBOutlet weak var mItemDescription: UITextView!
    
    @IBOutlet weak var mReviewsLabel: UILabel!
    
    @IBOutlet weak var mSummaryTextView: UITextView!
    
    @IBOutlet weak var mSizeLabel: UILabel!
    @IBOutlet weak var mSizeSelector: UISegmentedControl!
    
    @IBOutlet weak var mQuantityLabel: UILabel!
    @IBOutlet weak var mQuantityStepper: UIStepper!
    @IBOutlet weak var mQuantityAmountLabel: UILabel!

    @IBOutlet weak var mAddToCartButton: UIButton!
    
    var mReviewsList: [Review]?
    var mSelectedItemQuantity: Int?
    var mSelectedSize: String?
    
    var mCurrentQuantityXS: Int?
    var mCurrentQuantityS: Int?
    var mCurrentQuantityM: Int?
    var mCurrentQuantityL: Int?
    var mCurrentQuantityXL: Int?
    
    var mSelectedItem: Clothes?
    
    var mRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mRef = Database.database().reference()
        
        let itemUrl = URL(string: (mSelectedItem?.image)!)
        let placeHolderImage = UIImage(named: "ic_placeholder.png")
        mClothesImage.kf.setImage(with: itemUrl, placeholder: placeHolderImage)

        mPriceView.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        mPriceView.layer.cornerRadius = 17
        mPriceView.layer.borderWidth = 2
        mPriceView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        mPriceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        mItemTitle.text = mSelectedItem?.title
        mPriceLabel.text = "$" + (mSelectedItem?.price.description)!

        mReviewsLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailVC.segueToReviews))
        mReviewsLabel.addGestureRecognizer(tap)
        getItemReviewCount()

        mSummaryTextView.font = UIFont.systemFont(ofSize: 15)
        mSummaryTextView.text = mSelectedItem?.summary
        
        mCurrentQuantityXS = (mSelectedItem?.sizes["xs"])!
        mCurrentQuantityS = (mSelectedItem?.sizes["s"])!
        mCurrentQuantityM = (mSelectedItem?.sizes["m"])!
        mCurrentQuantityL = (mSelectedItem?.sizes["l"])!
        mCurrentQuantityXL = (mSelectedItem?.sizes["xl"])!
        
        mSizeLabel.text = "Size:"
        mSizeLabel.font = mSizeLabel.font.withSize(14)
        
        mSizeSelector.tintColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        
        mSizeSelector.setTitle("XS", forSegmentAt: 0)
        mSizeSelector.setTitle("S", forSegmentAt: 1)
        mSizeSelector.setTitle("M", forSegmentAt: 2)
        mSizeSelector.setTitle("L", forSegmentAt: 3)
        mSizeSelector.setTitle("XL", forSegmentAt: 4)

        disableZeroQuantitySegments()
        
        mQuantityLabel.text = "Quantity:"
        mQuantityLabel.font = mQuantityLabel.font.withSize(14)

        mQuantityStepper.tintColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)

        mQuantityAmountLabel.text = "0"
        mQuantityAmountLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        mAddToCartButton.setTitle("+", for: .normal)
        mAddToCartButton.frame = CGRect(x: 289, y: 546, width: 55, height: 55)
        mAddToCartButton.layer.cornerRadius = 0.5 * mAddToCartButton.bounds.size.width
        mAddToCartButton.clipsToBounds = true
        
        mAddToCartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 39)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showNoNetworkConnectionAlert(){
        
        let alert = UIAlertController(title: "No Network Connectivity", message: "Check network connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getItemReviewCount(){
        
        if(Connectivity.isConnectedToNetwork()){
            
            let id:Int = (mSelectedItem?.id)!
            let idString = String(id)
            
            var containerList = [Review]()
            
            mRef.child("inventory").child(idString).child("reviews").observe(.value) { (snapshot) in
                
                for item in snapshot.children.allObjects as! [DataSnapshot]{
                    
                    let itemDict = item.value as? [String: AnyObject]
                    let id  = itemDict?["id"] as! Int
                    let comment  = itemDict?["comment"] as! String
                    let rating  = itemDict?["rating"] as! Int
                    let date  = itemDict?["date"] as! String
                    
                    let review = Review(id: id, comment: comment, rating: rating, date: date)
                    
                    containerList.append(review)
                    
                    self.updateReviewCount(count: containerList.count)
                }
            }
        }else{
            showNoNetworkConnectionAlert()
        }
    }
    
    func updateReviewCount(count: Int){
        let reviewCountString: String = String(count)
        mReviewsLabel.text = "Reviews(" + reviewCountString + ")"
    }
    
    func disableZeroQuantitySegments(){
       
        for i in 0..<4{
            
            mSizeSelector.selectedSegmentIndex = i
        
            switch mSizeSelector.selectedSegmentIndex {
                
            case 0:
                if(mCurrentQuantityXS == 0){
                    mSizeSelector.setEnabled(false, forSegmentAt: 0)
                }else{
                    mSizeSelector.selectedSegmentIndex = 0
                }
            case 1:
                if(mCurrentQuantityS == 0){
                    mSizeSelector.setEnabled(false, forSegmentAt: 1)
                }
            case 2:
                if(mCurrentQuantityM == 0){
                    mSizeSelector.setEnabled(false, forSegmentAt: 2)
                }
            case 3:
                if(mCurrentQuantityL == 0){
                    mSizeSelector.setEnabled(false, forSegmentAt: 3)
                }
            case 4:
                if(mCurrentQuantityXL == 0){
                    mSizeSelector.setEnabled(false, forSegmentAt: 4)
                }
            default:
                break
            }
        }
    }
    
    @IBAction func sizeSegmentSelected(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            mSelectedSize = "XS"
        case 1:
            mSelectedSize = "S"
        case 2:
            mSelectedSize = "M"
        case 3:
            mSelectedSize = "L"
        case 4:
            mSelectedSize = "XL"
            
        default:
            mSelectedSize = "S"
        }
    }
    
    @IBAction func mQuantitySteps(_ sender: UIStepper) {
        mSelectedItemQuantity = Int(sender.value)
        mQuantityAmountLabel.text = String(format: "%.f", sender.value)
        mQuantityAmountLabel.sizeToFit()
    }

    @IBAction func addToCart(){

        if(Connectivity.isConnectedToNetwork()){
            let id: Int = (mSelectedItem?.id)!
            let idString = String(id)

            let title = mSelectedItem?.title
            let price = mSelectedItem?.price

            let size = mSelectedSize
            let quantity = Int(mQuantityStepper.value)

            let uid = UserDefaults.standard.string(forKey: "uid")

            let values = ["id": id, "title": title, "price": price, "size": size, "quantity": quantity] as [String : Any]

            self.mRef.child("users").child(uid!).child("cart").child(idString).setValue(values)
            
            self.tabBarController?.selectedIndex = 0
        }else{
            showNoNetworkConnectionAlert()
        }
    }
    
    @objc func segueToReviews(sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "itemReviewSegue", sender: mSelectedItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ItemReviewsVC{
            vc.mSelectedItem = sender as? Clothes
        }
    }
    
}
