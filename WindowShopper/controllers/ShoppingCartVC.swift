
import UIKit
import Firebase

class ShoppingCartVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mSummaryView: UIView!
    @IBOutlet weak var mSummaryLabel: UILabel!
    
    @IBOutlet weak var mEmptyView: UIView!
    
    @IBOutlet weak var mEmptyCartImage: UIImageView!
    
    @IBOutlet weak var mCheckoutTable: UITableView!
    
    @IBOutlet weak var mItemsQuantityLabel: UILabel!
    @IBOutlet weak var mTotalAmountLabel: UILabel!
    
    @IBOutlet weak var mButtonView: UIView!
    @IBOutlet weak var mCheckoutButton: UIButton!

    var mCheckoutList = [CartItem]()
    var mCheckOutItemIds = [Int]()
    
    var mTotalItems: Int = 0
    var mTotalAmount: Double = 0.00
    
    var mRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mRef = Database.database().reference()
        
        mSummaryView.frame = CGRect(x: 0, y: 67, width: 240, height: 36)
        mSummaryView.backgroundColor = UIColor.lightGray
        
        mSummaryLabel.frame = CGRect(x: 12, y: 9, width: 220, height: 21)
        mSummaryLabel.text = "Shopping Cart Summary:"
        mSummaryLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        mEmptyView.frame = CGRect(x: 0, y: 127, width: 414, height: 399)
        mEmptyView.backgroundColor = #colorLiteral(red: 0.9685532451, green: 0.9686691165, blue: 0.968513906, alpha: 1)
        
        mEmptyCartImage.frame = CGRect(x: 159.06, y: 156.94, width: 94, height: 87)
        mEmptyCartImage.image = UIImage(named: "ic_empty_cart.png")
        
        mCheckoutTable.frame = CGRect(x: 0, y: 127, width: 414, height: 399)
        mCheckoutTable.rowHeight = 65
        
        mItemsQuantityLabel.frame = CGRect(x: 42, y: 534, width: 80, height: 21)
        mItemsQuantityLabel.text = "Items: 0"
        mItemsQuantityLabel.font = UIFont.systemFont(ofSize: 17)
        
        mTotalAmountLabel.frame = CGRect(x: 213, y: 534, width: 156, height: 21)
        mTotalAmountLabel.text = "Total Amount: $0.00"
        mTotalAmountLabel.font = UIFont.systemFont(ofSize: 17)
        
        mButtonView.frame = CGRect(x: 20, y: 593, width: 374, height: 42)
        mButtonView.backgroundColor = #colorLiteral(red: 0.849943329, green: 0.7401361611, blue: 0.239743404, alpha: 1)
        
        mCheckoutButton.frame = CGRect(x: 0, y: 2, width: 374, height: 39)
        mCheckoutButton.setTitle("Checkout", for: .normal)
        mCheckoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        let uid = UserDefaults.standard.string(forKey: "uid")
        
        if(uid == nil){
            hideCartTable()
        }else{
            getCartItems()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showNoNetworkConnectionAlert(){
        
        let alert = UIAlertController(title: "No Network Connectivity", message: "Check network connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCartItems(){
     
        if(Connectivity.isConnectedToNetwork()){
            
            let uid = UserDefaults.standard.string(forKey: "uid")
            
            mRef.child("users").child(uid!).child("cart").observe(.value) { (snapshot) in
                
                for item in snapshot.children.allObjects as! [DataSnapshot]{
                    
                    let cartDict = item.value as? [String: AnyObject]
                    let id  = cartDict?["id"] as! Int
                    let title  = cartDict?["title"] as! String
                    let price  = cartDict?["price"] as! Double
                    let quantity = cartDict?["quantity"] as! Int
                    let size = cartDict?["size"] as! String
                    
                    let cartItem = CartItem(id: id, title: title, price: price, size: size, quantity: quantity)
                    
                    self.mCheckoutList.append(cartItem)
                    self.mCheckOutItemIds.append(id)

                    self.mCheckoutTable.reloadData()
                    self.totalAmountForItems()
                }
            }
        }else{
            showNoNetworkConnectionAlert()
        }
    }
    
    func hideCartTable(){
        
        if(mCheckoutList.isEmpty){
            mCheckoutTable.isHidden = true
            mEmptyCartImage.isHidden = false
        }else{
            mCheckoutTable.isHidden = false
            mEmptyCartImage.isHidden = true
        }
    }
    
    func totalAmountForItems(){
        
        mTotalAmount = 0.00
        mTotalItems = 0
        
        mCheckoutList.forEach { (item) in
            mTotalItems += item.quantity
            mTotalAmount += item.price * Double(item.quantity)
            
            mItemsQuantityLabel.text = "Quantity:  " + String(mTotalItems)
            mItemsQuantityLabel.sizeToFit()
            
            mTotalAmountLabel.text = "Total Amount: $" + String(mTotalAmount)
            mTotalAmountLabel.sizeToFit()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mCheckoutList.count
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        mCheckoutTable.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let item = mCheckoutList[indexPath.row]
            let id: Int = item.id
            let idString = String(id)
            
            let uid = UserDefaults.standard.string(forKey: "uid")
            
            mRef.child("users").child(uid!).child("cart").child(idString).removeValue()
            
            mCheckoutList.remove(at: indexPath.row)
            mCheckoutTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            mCheckoutTable.reloadData()
        }
        totalAmountForItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CheckoutCell = mCheckoutTable.dequeueReusableCell(withIdentifier: "checkoutCell") as! CheckoutCell
        
        let item = mCheckoutList[indexPath.row]
        
        cell.mItemTitle.text = item.title
        cell.mItemTitle.sizeToFit()
        
        cell.mQuantityStepper.tag = indexPath.row
        cell.mQuantityStepper.value = Double(item.quantity)
        
        cell.mQuantityStepper.addTarget(self, action: #selector(quantitySteps(sender:)), for: .valueChanged)
        
        cell.mQuantityLabel.text = String("Quantity: " + String(item.quantity))
        cell.mQuantityLabel.sizeToFit()
        
        cell.mPriceLabel.text = "$" + String(item.price * Double(item.quantity))
        cell.mPriceLabel.sizeToFit()
        
        return cell
    }
    
    @objc func quantitySteps(sender: UIStepper) {
        
        let item = mCheckoutList[sender.tag]
        
        item.quantity = Int(sender.value)

        mCheckoutTable.reloadData()
        totalAmountForItems()
    }

    @IBAction func checkoutButtonPressed(){
    
        performSegue(withIdentifier: "transactionSegue", sender: mTotalAmount)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TransactionVC{
            vc.mTotalAmount = sender as? Double
        }
    }
}