
import UIKit
import Cosmos

class ReviewCell: UITableViewCell {

    @IBOutlet weak var mRatingScale: CosmosView!
    @IBOutlet weak var mDateLabel: UILabel!
    @IBOutlet weak var mCommentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mRatingScale.isUserInteractionEnabled = false
        mRatingScale.frame = CGRect(x: 20, y: 7, width: 108, height: 14)
        mRatingScale.settings.filledColor = #colorLiteral(red: 0.849943329, green: 0.7401361611, blue: 0.239743404, alpha: 1)
        mRatingScale.settings.minTouchRating = 1
        mRatingScale.settings.starSize = 17
        mRatingScale.settings.totalStars = 5
        
        mDateLabel.textColor = UIColor.lightGray
        mDateLabel.frame = CGRect(x: 320, y: 7, width: 79, height: 21)
        mDateLabel.font = mDateLabel.font.withSize(13)
        
        mCommentTextView.frame = CGRect(x: 15, y: 17, width: 390, height: 64)
        mCommentTextView.isEditable = false
        mCommentTextView.font = mCommentTextView.font?.withSize(14)
    }

}
