
import UIKit

class CartItem: NSObject {
    
    var id: Int
    var title: String
    var price: Double
    var size: String
    var quantity: Int
    
    init(id: Int, title: String, price: Double, size: String, quantity: Int) {
        self.id = id
        self.title = title
        self.price = price
        self.size = size
        self.quantity = quantity
    }

}
