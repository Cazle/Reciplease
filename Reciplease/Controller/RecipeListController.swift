import Foundation
import UIKit

final class RecipeListController: UIViewController {
    
    @IBOutlet weak var barNavigation: UINavigationItem!
    
    var recipeFromRecipeList = [Hit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(tapBackButton))
        navigationItem.leftBarButtonItem = leftButton
    }
    @objc func tapBackButton() {
        print("back button pressed")
        navigationController?.popViewController(animated: true)
    }
}
