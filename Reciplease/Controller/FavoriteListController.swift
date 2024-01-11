import Foundation
import CoreData
import UIKit

final class FavoriteListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var storedRecipes: [RecipeEntity]?
    let context = (UIApplication.shared.delegate as! AppDelegate).backgroundContext
    let recipeViewCell = RecipeViewCell()
   
    override func viewDidLoad() {
         print("Oui")
       
        tableView.register(recipeViewCell.nibRecipeViewCell(), forCellReuseIdentifier: recipeViewCell.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchRecipes()
    }
    func fetchRecipes() {
        do {
            self.storedRecipes = try context.fetch(RecipeEntity.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Faiiling retriving data")
        }
    }
}
extension FavoriteListController: UITableViewDelegate, UITableViewDataSource {
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
        cell.settingFavoriteCell(recipe: recipe)
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {action, view, completionHandler in
            guard let recipes = self.storedRecipes else {
                return
            }
            let recipeToRemove = recipes[indexPath.row]
            self.context.delete(recipeToRemove)
            print("Preparing to remove the recipe")
            do {
                print("Trying to remove the recipe")
                 try self.context.save()
                print("Deletion done !")
            } catch {
                print("error")
            }
            self.fetchRecipes()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
