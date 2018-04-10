
import UIKit

class Review: NSObject {
    
    var id: Int
    var comment: String
    var date: String
    var rating: Int
    
    init(id: Int, comment: String, rating: Int, date: String) {
        self.id = id
        self.comment = comment
        self.rating = rating
        self.date = date
    }
    
}
