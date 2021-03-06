
import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var mBannerView: UIView!
    @IBOutlet weak var mBannerLabel: UILabel!
    
    @IBOutlet weak var mMensPanelImage: UIImageView!
    @IBOutlet weak var mWomensPanelImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mBannerView.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        mMensPanelImage.image = UIImage(named: "mens_panel.png")
        mWomensPanelImage.image = UIImage(named: "womens_panel.png")

        mMensPanelImage.isUserInteractionEnabled = true
        mWomensPanelImage.isUserInteractionEnabled = true
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(HomeVC.segueToMens))
        mMensPanelImage.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(HomeVC.segueToWomens))
        mWomensPanelImage.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func segueToMens(){
        performSegue(withIdentifier: "mensClothingSegue", sender: self)
    }
    
    @objc func segueToWomens(){
        performSegue(withIdentifier: "womensClothingSegue", sender: self)
    }

}
