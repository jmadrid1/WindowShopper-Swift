
import UIKit
import Cosmos

class ReviewCell: UITableViewCell {

    @IBOutlet weak var mRatingScale: CosmosView!
    @IBOutlet weak var mDateLabel: UILabel!
    @IBOutlet weak var mCommentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mRatingScale.isUserInteractionEnabled = false
        mRatingScale.settings.filledColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        mRatingScale.settings.minTouchRating = 1
        mRatingScale.settings.starSize = 17
        mRatingScale.settings.totalStars = 5
        
        mDateLabel.textColor = UIColor.lightGray
        mDateLabel.font = mDateLabel.font.withSize(13)
  
        mCommentTextView.isEditable = false
        mCommentTextView.font = mCommentTextView.font?.withSize(14)
    }

}
