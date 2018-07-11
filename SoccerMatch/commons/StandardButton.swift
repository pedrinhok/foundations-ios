import UIKit

@IBDesignable
class StandardButton: UIButton {
    
    var tempColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tempColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tempColor = backgroundColor
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
    
    public func inactive() {
        isEnabled = false
        layer.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1).cgColor
    }
    
    public func active() {
        isEnabled = true
        layer.backgroundColor = tempColor?.cgColor
    }
    
}
