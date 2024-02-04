import Foundation
import UIKit

final class FavoriteListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var storedRecipes: [RecipeEntity]?
    var recipeToSend: RecipeEntity?
    let recipeViewCell = RecipeViewCell()
    let coreDataManager = CoreDataManager()
   
    override func viewDidLoad() {
        tableView.register(recipeViewCell.nibRecipeViewCell(), forCellReuseIdentifier: recipeViewCell.identifier)
        makeAccessibilityComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchRecipes()
        displayingMessageIfFavoritesAreEmpty()
    }
    
    func makeAccessibilityComponents() {
        tableView.accessibilityLabel = "All your recipes in favorites"
        
        messageLabel.accessibilityLabel = "You don't have any recipes in your favorties ! To add any recipes in your favorites you need to : Search a recipe with your ingredients. Then click on a recipe that you like. And finally, click on the Green Star on the top right of the screen. And tada ! It appears on your favorites !"
    }
    
    func displayingMessageIfFavoritesAreEmpty() {
        guard let store = storedRecipes else { return }
        if store.isEmpty {
            messageLabel.isHidden = false
        } else {
            messageLabel.isHidden = true
        }
    }
    
    func fetchRecipes() {
        do {
            try storedRecipes = coreDataManager.fetchingRecipes()
            self.tableView.reloadData()
        } catch {
            presentAlert(message: "Error occured. Failed to fetch recipes.")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "favoriteToDescription", let descriptionController = segue.destination as? FavoriteDescriptionController else { return }
        descriptionController.selectedRecipe = recipeToSend
    }
}

extension FavoriteListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRecipe = storedRecipes else {
            return
        }
        recipeToSend = selectedRecipe[indexPath.row]
        performSegue(withIdentifier: "favoriteToDescription", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipes = storedRecipes else {
            return 0
        }
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: recipeViewCell.identifier, for: indexPath) as? RecipeViewCell else {
            return UITableViewCell()
        }
        guard let storedRecipe = storedRecipes else {
            return UITableViewCell()
        }
        let recipe = storedRecipe[indexPath.row]
        
        cell.accessibilityHint = "Tap one time, to access the recipe"
        cell.accessibilityTraits = .button
        cell.accessibilityLabel = "Cell containing recipe"
        
        cell.settingFavoriteCell(recipe: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {context, view, completionHandler in
            guard let recipes = self.storedRecipes else {
                return
            }
            
            let recipeToRemove = recipes[indexPath.row]
            self.coreDataManager.deletingRecipe(deleting: recipeToRemove)
            
            do {
                try self.coreDataManager.savingContext()
            } catch {
                self.presentAlert(message: "Error occured. Can't delete the recipe.")
            }
            
            
             
            self.fetchRecipes()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
