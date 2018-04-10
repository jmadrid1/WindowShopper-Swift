
import UIKit

class CheckoutCell: UITableViewCell {
    
    @IBOutlet weak var mItemTitle: UILabel!
    
    @IBOutlet weak var mQuantityLabel: UILabel!
    @IBOutlet weak var mPriceLabel: UILabel!
    @IBOutlet weak var mQuantityStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mItemTitle.font = UIFont.boldSystemFont(ofSize: 17)
        
        mQuantityLabel.frame = CGRect(x: 46, y: 27, width: 99, height: 21)
        mQuantityLabel.font = UIFont.systemFont(ofSize: 17)
        
        mQuantityStepper.frame = CGRect(x: 177, y: 23, width: 94, height: 29)
        mQuantityStepper.tintColor = #colorLiteral(red: 0.849943329, green: 0.7401361611, blue: 0.239743404, alpha: 1)
        
        mPriceLabel.frame = CGRect(x: 325, y: 26, width: 82, height: 21)
        mPriceLabel.font = UIFont.systemFont(ofSize: 17)
    }    

}
