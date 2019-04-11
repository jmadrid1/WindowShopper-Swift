
import UIKit
import Firebase

class TransactionVC: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var mCardInformationView: UIView!
    @IBOutlet weak var mEnterInformationLabel: UILabel!
    
    @IBOutlet weak var mCreditCardNumberLabel: UILabel!
    @IBOutlet weak var mCreditCardNumberTextField: UITextField!
    @IBOutlet weak var mCVVLabel: UILabel!
    @IBOutlet weak var mCVVTextField: UITextField!
    
    @IBOutlet weak var mFirstNameLabel: UILabel!
    @IBOutlet weak var mFirstNameTextField: UITextField!
    
    @IBOutlet weak var mLastNameLabel: UILabel!
    @IBOutlet weak var mLastNameTextField: UITextField!
   
    @IBOutlet weak var mAddressLabel: UILabel!
    @IBOutlet weak var mAddressTextField: UITextField!
    
    @IBOutlet weak var mCityLabel: UILabel!
    @IBOutlet weak var mCityTextField: UITextField!
    
    @IBOutlet weak var mStateLabel: UILabel!
    
    @IBOutlet weak var mZipcodeLabel: UILabel!
    @IBOutlet weak var mZipcodeTextField: UITextField!
    
    @IBOutlet weak var mTotalAmountLabel: UILabel!
    
    @IBOutlet weak var mButtonView: UIView!
    @IBOutlet weak var mTransactionButton: UIButton!
    
    @IBOutlet weak var mStateTextField: UITextField!
    @IBOutlet weak var mStatePicker: UIPickerView!

    var mCheckOutItemIds = [Int]()
    
    
    let mStatePickerOptions = ["AK", "AL", "AR", "AS", "AZ","CA", "CO","CT", "DC", "DE", "FL",
                               "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA",
                               "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH",
                               "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "PR", "RI", "SC",
                               "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"]
    
    var mSelectedState: String = "AZ"
 
    var mTotalAmount: Double?
    
    var mRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mCardInformationView.frame = CGRect(x: 40, y: 105, width: 294, height: 52)
        mCardInformationView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        mEnterInformationLabel.text = "Enter Credit Card Information: "
        mEnterInformationLabel.frame = CGRect(x: 19, y: 15, width: 272, height: 21)
        
        mCreditCardNumberLabel.text = "Credit Card Number:"
        mCreditCardNumberLabel.frame = CGRect(x: 20, y: 190, width: 134, height: 17)
        mCreditCardNumberTextField.frame = CGRect(x: 159, y: 183, width: 228, height: 30)
        
        mCVVLabel.text = "CVV:"
        mCVVLabel.frame = CGRect(x: 128, y: 227, width: 23, height: 17)
        mCVVTextField.frame = CGRect(x: 159, y: 221, width: 97, height: 30)
        
        mFirstNameLabel.text = "First Name:"
        mFirstNameLabel.frame = CGRect(x: 77, y: 265, width: 74, height: 17)
        mFirstNameTextField.frame = CGRect(x: 159, y: 259, width: 145, height: 30)
        
        mLastNameLabel.text = "Last Name:"
        mLastNameLabel.frame = CGRect(x: 81, y: 303, width: 73, height: 17)
        mLastNameTextField.frame = CGRect(x: 159, y: 297, width: 145, height: 30)
        
        mAddressLabel.text = "Street Address:"
        mAddressLabel.frame = CGRect(x: 60, y: 342, width: 94, height: 16)
        mAddressTextField.frame = CGRect(x: 159, y: 336, width: 157, height: 30)
        
        mCityLabel.text = "City:"
        mCityLabel.frame = CGRect(x: 122, y: 380, width: 28, height: 16)
        mCityTextField.frame = CGRect(x: 159, y: 374, width: 97, height: 30)
        
        mStateLabel.text = "State:"
        mStateLabel.frame = CGRect(x: 275, y: 380, width: 38, height: 17)
        mStateTextField.frame = CGRect(x: 323, y: 374, width: 57, height: 30)
        
        mZipcodeLabel.text = "Zipcode:"
        mZipcodeLabel.frame = CGRect(x: 93, y: 418, width: 57, height: 17)
        mZipcodeTextField.frame = CGRect(x: 159, y: 412, width: 112, height: 30)
        
        mCreditCardNumberLabel.font = UIFont.systemFont(ofSize: 14)
        mCVVLabel.font = UIFont.systemFont(ofSize: 14)
        mFirstNameLabel.font = UIFont.systemFont(ofSize: 14)
        mLastNameLabel.font = UIFont.systemFont(ofSize: 14)
        mAddressLabel.font = UIFont.systemFont(ofSize: 14)
        mCityLabel.font = UIFont.systemFont(ofSize: 14)
        mStateLabel.font = UIFont.systemFont(ofSize: 14)
        mZipcodeLabel.font = UIFont.systemFont(ofSize: 14)
        
        mCreditCardNumberTextField.tag = 0
        mCVVTextField.tag = 1
        mFirstNameTextField.tag = 2
        mLastNameTextField.tag = 3
        mAddressTextField.tag = 4
        mCityTextField.tag = 5
        mZipcodeTextField.tag = 6
        mStateTextField.tag = 7
        
        mCreditCardNumberTextField.placeholder = "XXXX-XXXX-XXXX-XXXX"
        mCVVTextField.placeholder = "XXX"
        mFirstNameTextField.placeholder = "Enter First Name"
        mLastNameTextField.placeholder = "Enter Last Name"
        mAddressTextField.placeholder = "Enter Street Address"
        mCityTextField.placeholder = "Enter City"
        mZipcodeTextField.placeholder = "Enter Zipcode"
        
        mCreditCardNumberTextField.returnKeyType = UIReturnKeyType.done
        mCVVTextField.returnKeyType = UIReturnKeyType.done
        mFirstNameTextField.returnKeyType = UIReturnKeyType.done
        mLastNameTextField.returnKeyType = UIReturnKeyType.done
        mAddressTextField.returnKeyType = UIReturnKeyType.done
        mCityTextField.returnKeyType = UIReturnKeyType.done
        
        mCreditCardNumberTextField.keyboardType = UIKeyboardType.numberPad
        mCVVTextField.keyboardType = UIKeyboardType.numberPad
        mZipcodeTextField.keyboardType = UIKeyboardType.numberPad
        
        mStatePicker.removeFromSuperview()
        mStatePicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        
        mStateTextField.text = mSelectedState
        mStateTextField.inputView = mStatePicker
        
        mTotalAmountLabel.text = "Amount Charged:   $" + String(format: "%.2f", mTotalAmount!)
        mTotalAmountLabel.frame = CGRect(x: 54, y: 504, width: 220, height: 21)
        mTotalAmountLabel.sizeToFit()
        
        addDoneButton()
        
        mButtonView.frame = CGRect(x: 67, y: 558, width: 240, height: 52)
        mButtonView.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        
        mTransactionButton.setTitle("Commit Transaction", for: .normal)
        mTransactionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        mTransactionButton.frame = CGRect(x: 0, y: 0, width: 240, height: 52)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showNoNetworkConnectionAlert(){
        
        let alert = UIAlertController(title: "No Network Connectivity", message: "Check network connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showTransactionAlert(){
        
        let alert = UIAlertController(title: "Transaction Completed", message: "Your transaction has been completed!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
        
            self.tabBarController?.selectedIndex = 0
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
            
        case 0:
            mCreditCardNumberTextField.resignFirstResponder()
            return true
            
        case 1:
            mCVVTextField.resignFirstResponder()
            return true
            
        case 2:
            mFirstNameTextField.resignFirstResponder()
            return true
            
        case 3:
            mLastNameTextField.resignFirstResponder()
            return true
            
        case 4:
            mAddressTextField.resignFirstResponder()
            return true
            
        case 5:
            mCityTextField.resignFirstResponder()
            return true
            
        case 6:
            mZipcodeTextField.resignFirstResponder()
            return true
            
        default:
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        switch textField.tag {
            
        case 0:
            return newLength <= 16 && allowedCharacters.isSuperset(of: characterSet)
            
        case 1:
            return newLength <= 3 && allowedCharacters.isSuperset(of: characterSet)
            
        case 2:
            return newLength <= 25
            
        case 3:
            return newLength <= 25
            
        case 4:
            return newLength <= 35
            
        case 5:
            return newLength <= 25
            
        case 6:
            return newLength <= 5 && allowedCharacters.isSuperset(of: characterSet)

        default:
            return newLength <= 15
        }
    }
    
    func addDoneButton(){
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(TransactionVC.resignDigitTextFields))
        
        toolbarDone.items = [barBtnDone]
        
        mCreditCardNumberTextField.inputAccessoryView = toolbarDone
        mCVVTextField.inputAccessoryView = toolbarDone
        mStateTextField.inputAccessoryView = toolbarDone
        mZipcodeTextField.inputAccessoryView = toolbarDone
    }
    
    @objc func resignDigitTextFields(){
        mCreditCardNumberTextField.resignFirstResponder()
        mCVVTextField.resignFirstResponder()
        mStateTextField.resignFirstResponder()
        mZipcodeTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mStatePickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(mStatePickerOptions[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        mStatePicker.isHidden = true
        mSelectedState = mStatePickerOptions[row]
        mStateTextField.text = mSelectedState
    }
    
    @IBAction func commitTransaction(){
        if(Connectivity.isConnectedToNetwork()){
           showTransactionAlert()
        }else{
            showNoNetworkConnectionAlert()
        }
    }

}
