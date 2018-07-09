import UIKit

@IBDesignable
class StandardButton: UIButton {

    var tempBackgroundColor: UIColor?

    override init(frame: CGRect) {
        super.init(frame: frame)
        tempBackgroundColor = backgroundColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tempBackgroundColor = backgroundColor
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
    
    public func disable() {
        isEnabled = false
        layer.backgroundColor = UIColor.gray.cgColor
        
    }
    
    public func enable() {
        isEnabled = true
        layer.backgroundColor = tempBackgroundColor?.cgColor
    }

}
