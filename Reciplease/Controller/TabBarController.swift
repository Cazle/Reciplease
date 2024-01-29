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
        
        items[0].accessibilityLabel = "Search"
        items[1].accessibilityLabel = "Favorite"
        
        for item in items {
            item.setTitleTextAttributes([NSAttributedString.Key.font: normalFont], for: .normal)
        }
    }
}



