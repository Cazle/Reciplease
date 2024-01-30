import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
      settingButton()
    }
    
    func settingButton() {
        guard let items = tabBar.items else {
            return
        }
        
        guard let normalFont = UIFont(name: "Chalkduster", size: 23) else {
            return
        }
        
        items[0].accessibilityLabel = "Go to search page"
        items[0].accessibilityTraits = .button
        
        items[1].accessibilityLabel = "Go to favorite page"
        items[1].accessibilityTraits = .button
        
        for item in items {
            item.setTitleTextAttributes([NSAttributedString.Key.font: normalFont], for: .normal)
        }
    }
}



