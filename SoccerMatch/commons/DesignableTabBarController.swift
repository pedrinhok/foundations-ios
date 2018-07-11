import UIKit

class DesignableTabBarController: UITabBarController {

    @IBInspectable var normalTint: UIColor = UIColor(red:205/255, green: 205/255, blue: 205/255, alpha: 1){
        didSet {
            
            UITabBar.appearance().tintColor = normalTint
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: normalTint], for: UIControlState())
        }
    }
    
    @IBInspectable var selectedTint: UIColor = UIColor(red:125/255, green: 210/255, blue: 115/255, alpha: 1) {
        didSet {
            
            UITabBar.appearance().tintColor = selectedTint
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedTint], for:UIControlState.selected)
        }
    }
    
    @IBInspectable var fontName: String = "" {
        didSet {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: normalTint, NSAttributedStringKey.font: UIFont(name: fontName, size: 11)!], for: UIControlState())
        }
    }
    
    @IBInspectable var firstSelectedImage: UIImage? {
        didSet {
            if let image = firstSelectedImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[0].selectedImage = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            }
        }
    }
    
    @IBInspectable var secondSelectedImage: UIImage? {
        didSet {
            if let image = secondSelectedImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[1].selectedImage = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            }
        }
    }
    
    @IBInspectable var thirdSelectedImage: UIImage? {
        didSet {
            if let image = thirdSelectedImage {
                var tabBarItems = self.tabBar.items as [UITabBarItem]?
                tabBarItems?[2].selectedImage = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in self.tabBar.items as [UITabBarItem]! {
            if let image = item.image {
                item.image = image.imageWithColor(tintColor: self.normalTint).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
        }
    }
}

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0);
        context!.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context!.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
