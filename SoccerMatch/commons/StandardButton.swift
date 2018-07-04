import UIKit

@IBDesignable
class StandardButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    var corner: CGFloat = 0 {
        didSet {
            layer.cornerRadius = corner
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable
    var centerAlignment: Bool = true {
        didSet {
            if centerAlignment {
                contentHorizontalAlignment = .center
            } else {
                contentHorizontalAlignment = .left
            }
        }
    }

}
