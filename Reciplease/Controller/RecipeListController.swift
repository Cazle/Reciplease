import Foundation
import UIKit

final class RecipeListController: UIViewController {
    
    @IBOutlet weak var barNavigation: UINavigationItem!
    
    var cellIdentifer = "recipeCell"
    
    var recipes = [Hit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
    }
    func backButton() {
        let leftButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(tapBackButton))
        navigationItem.leftBarButtonItem = leftButton
    }
    @objc func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension RecipeListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? RecipeViewCell else {
            return UITableViewCell()
        }
        let recipes = recipes[indexPath.row]
        let name = recipes.recipe.label
        let image = recipes.recipe.image
        
        let getIngredients = recipes.recipe.ingredients
        let ingredients = getIngredients.map {$0.food}.joined(separator: ", ")
        
        cell.settingRecipeCell(name: name, ingredients: ingredients)
        DispatchQueue.main.async {
            cell.settingTheImage(url: image)
        }
        
        return cell
    }
}
