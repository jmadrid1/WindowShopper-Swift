
import UIKit

class CheckoutCell: UITableViewCell {
    
    @IBOutlet weak var mItemTitle: UILabel!
    
    @IBOutlet weak var mQuantityLabel: UILabel!
    @IBOutlet weak var mPriceLabel: UILabel!
    @IBOutlet weak var mQuantityStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mItemTitle.font = UIFont.boldSystemFont(ofSize: 17)
        
        mQuantityLabel.font = UIFont.systemFont(ofSize: 17)
        mQuantityStepper.tintColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        
        mPriceLabel.font = UIFont.systemFont(ofSize: 17)
    }    

}
