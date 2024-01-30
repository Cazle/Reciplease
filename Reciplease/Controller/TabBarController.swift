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
        items[0].accessibilityHint = "Tap to be on the search part of Reciplease"
        
        items[1].accessibilityLabel = "Go to favorite page"
        items[1].accessibilityTraits = .button
        items[1].accessibilityHint = "Tap to be on the favorite part of Reciplease"
        
        for item in items {
            item.setTitleTextAttributes([NSAttributedString.Key.font: normalFont], for: .normal)
        }
    }
}



