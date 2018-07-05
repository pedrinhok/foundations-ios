import UIKit

class CircleImage: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        construct()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        construct()
    }
    
    func construct() {
        layer.cornerRadius = frame.size.width / 2
    }
    
}
