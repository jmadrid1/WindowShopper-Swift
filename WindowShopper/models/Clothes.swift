
import UIKit


class Clothes: NSObject {
    
    var id: Int
    var category: String
    var title: String
    var summary: String
    var price: Double
    var image: String
    var specifics: String
    var sizes: Dictionary<String, Int>
    
    
    init(id: Int, category: String, title: String, summary: String, price: Double, image: String, specifics: String, sizes: Dictionary<String,Int>) {
        self.id = id
        self.category = category
        self.title = title
        self.summary = summary
        self.price = price
        self.image = image
        self.specifics = specifics
        self.sizes = sizes
    }

}
