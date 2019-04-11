
import UIKit
import Firebase
import Kingfisher

class WomensClothingVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var mEmptyView: UIView!
    @IBOutlet weak var mEmptyCollectionImage: UIImageView!
    
    @IBOutlet weak var mClothesCollection: UICollectionView!
    
    var mDressesList = [Clothes]()
    var mShirtsList = [Clothes]()
    var mPantsList = [Clothes]()
    
    var mRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mRef = Database.database().reference()
        mEmptyView.isHidden = true
        mEmptyView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        mEmptyCollectionImage.image = UIImage(named: "ic_empty_list.png")
        
        getClothingItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getClothingItems(){
        
        if(Connectivity.isConnectedToNetwork()){
            
            mDressesList.removeAll()
            mPantsList.removeAll()
            mShirtsList.removeAll()
            
            var containerList = [Clothes]()
            
            mRef.child("inventory").observe(.value) { (snapshot) in
                
                for item in snapshot.children.allObjects as! [DataSnapshot]{
                    
                    let itemDict = item.value as? [String: AnyObject]
                    let id  = itemDict?["id"] as! Int
                    let title  = itemDict?["title"] as! String
                    let summary  = itemDict?["summary"] as! String
                    let category  = itemDict?["category"] as! String
                    let price  = itemDict?["price"] as! Double
                    let image = itemDict?["image"] as! String
                    let specifics = itemDict?["specifics"] as! String
                    let quantity = itemDict?["sizes"] as! Dictionary<String,Int>
         
                    let clothes = Clothes(id: id, category: category, title: title, summary: summary, price: price, image: image, specifics: specifics, sizes: quantity)
                    
                    containerList.append(clothes)
                    self.filterClothes(clothes: containerList)
                    
                    containerList.removeAll()
                    
                    self.mClothesCollection.reloadData()
                }
            }
        }else{
            hideCollection()
            showNoNetworkConnectionAlert()
        }
    }
    
    func filterClothes(clothes: Array<Clothes>){
        
        for Clothes in clothes{
            
            let category = Clothes.category
            let specifics = Clothes.specifics
            
            switch (category){
                
            case "dresses":
                if(specifics == "womens"){
                    mDressesList.append(Clothes)
                }
                break;
                
            case "shirts":
                if(specifics == "womens"){
                    mShirtsList.append(Clothes)
                }
                break;
                
            case "pants":
                if(specifics == "womens"){
                    mPantsList.append(Clothes)
                }
                break;
                
            default:
                break;
            }
        }
    }
    
    func hideCollection(){
        
        if(mShirtsList.count == 0){
            mClothesCollection.isHidden = true
            mEmptyView.isHidden = false
        }else{
            mClothesCollection.isHidden = false
            mEmptyView.isHidden = true
        }
    }
    
    func showNoNetworkConnectionAlert(){
        
        let alert = UIAlertController(title: "No Network Connectivity", message: "Check network connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch (section){
        case 0:
            return mDressesList.count
        case 1:
            return mShirtsList.count
        case 2:
            return mPantsList.count
            
        default:
            break
        }
        
        return mShirtsList.count + mDressesList.count + mPantsList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionHeader", for: indexPath) as! CollectionHeader
        
        switch indexPath.section {
        case 0:
            header.mHeaderTitleLabel.text = "Dresses"
            header.mHeaderTitleLabel.sizeToFit()
            
            break;
            
        case 1:
            header.mHeaderTitleLabel.text = "Shirts"
            header.mHeaderTitleLabel.sizeToFit()
            
            break
        case 2:
            header.mHeaderTitleLabel.text = "Pants"
            header.mHeaderTitleLabel.sizeToFit()
            break
        default:
            break
        }
        
        return header;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ClothesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "clothesCell", for: indexPath) as! ClothesCell
        
        var item: Clothes?
        
        switch (indexPath.section) {
        case 0:
            item = mDressesList[indexPath.row]
            break;
        case 1:
            item = mShirtsList[indexPath.row]
            break;
            
        case 2:
            item = mPantsList[indexPath.row]
            break;
            
        default:
            break;
        }
        
        let itemUrl = URL(string: (item?.image)!)
        let placeHolderImage = UIImage(named: "ic_placeholder.png")
        cell.mClothesImage.kf.setImage(with: itemUrl, placeholder: placeHolderImage)
        
        cell.mTitle.text = item?.title
        cell.mTitle.textColor = UIColor.white

        cell.mPriceView.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        let price:Double = (item?.price)!
        cell.mPrice.text = "$" + String(price)
        cell.mPrice.font = UIFont.boldSystemFont(ofSize: 11)
        cell.mPrice.textColor = UIColor.white
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var itemSelected: Clothes?
        
        switch (indexPath.section) {
        case 0:
            itemSelected = mDressesList[indexPath.row]
            break;
        case 1:
            itemSelected = mShirtsList[indexPath.row]
            break;
            
        case 2:
            itemSelected = mPantsList[indexPath.row]
            break;
            
        default:
            break;
        }
        
        performSegue(withIdentifier: "itemDetailSegue", sender: itemSelected)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ItemDetailVC{
            vc.mSelectedItem = (sender as? Clothes)!
        }
    }

}
