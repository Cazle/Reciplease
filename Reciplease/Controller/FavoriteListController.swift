import Foundation
import CoreData
import UIKit

final class FavoriteListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var storedRecipes: [RecipeEntity]?
    var recipeToSend: RecipeEntity?
    let context = (UIApplication.shared.delegate as! AppDelegate).backgroundContext
    let recipeViewCell = RecipeViewCell()
    lazy var coreDataManager = CoreDataManager(context: context)
   
    override func viewDidLoad() {
        tableView.register(recipeViewCell.nibRecipeViewCell(), forCellReuseIdentifier: recipeViewCell.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchRecipes()
    }
    func fetchRecipes() {
        coreDataManager.fetchRecipes { recipes in
            self.storedRecipes = recipes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        cell.settingFavoriteCell(recipe: recipe)
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {context, view, completionHandler in
            guard let recipes = self.storedRecipes else {
                return
            }
            let recipeToRemove = recipes[indexPath.row]
            self.context.delete(recipeToRemove)
            do {
                 try self.context.save()
            } catch {
                print("error")
            }
            self.fetchRecipes()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
