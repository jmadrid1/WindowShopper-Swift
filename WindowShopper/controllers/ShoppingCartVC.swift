
import UIKit
import Firebase

class ShoppingCartVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var mEmptyView: UIView!
    
    @IBOutlet weak var mEmptyCartImage: UIImageView!
    
    @IBOutlet weak var mCheckoutTable: UITableView!
    
    @IBOutlet weak var mItemsQuantityLabel: UILabel!
    @IBOutlet weak var mTotalAmountLabel: UILabel!
    
    @IBOutlet weak var mCheckoutButton: UIButton!

    var mCheckoutList = [CartItem]()
    var mCheckOutItemIds = [Int]()
    
    var mTotalItems: Int = 0
    var mTotalAmount: Double = 0.00
    
    var mRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mRef = Database.database().reference()

        mEmptyView.backgroundColor = #colorLiteral(red: 0.9685532451, green: 0.9686691165, blue: 0.968513906, alpha: 1)

        mEmptyCartImage.image = UIImage(named: "ic_empty_cart.png")

        mCheckoutTable.rowHeight = 65

        mItemsQuantityLabel.text = "Items: 0"
        mItemsQuantityLabel.font = UIFont.systemFont(ofSize: 17)
  
        mTotalAmountLabel.text = "Total Amount: $0.00"
        mTotalAmountLabel.font = UIFont.systemFont(ofSize: 17)

        mCheckoutButton.setTitle("Checkout", for: .normal)
        mCheckoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        mCheckoutButton.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        mCheckoutButton.layer.cornerRadius = 15
        mCheckoutButton.layer.borderWidth = 2
        
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
