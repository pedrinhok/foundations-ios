import UIKit

@IBDesignable
class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let iv = imageView, iv.image != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 30), bottom: 5, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: iv.frame.width)
        }
        contentHorizontalAlignment = .left
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

    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)

        setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1), for: state)
    }

}
