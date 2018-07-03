import UIKit

class CircleImage: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        round()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        round()
    }

    func round() {
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.width / 2
    }

}
