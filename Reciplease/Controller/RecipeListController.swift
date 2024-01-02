import Foundation
import UIKit

final class RecipeListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barNavigation: UINavigationItem!
    
    var recipes = [Hit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        tableView.register(RecipeViewCell().nib(), forCellReuseIdentifier: RecipeViewCell().identifier)
    }
    func backButton() {
        let leftButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(tapBackButton))
        navigationItem.leftBarButtonItem = leftButton
    }
    @objc func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "recipeToDescription",
            let selectedIndexPath = tableView.indexPathForSelectedRow,
            let descriptionController = segue.destination as? DescriptionViewController 
        else {
            return
        }
        let selectedRecipe = recipes[selectedIndexPath.row]
        descriptionController.receivedRecipe = [selectedRecipe]
        }
}

extension RecipeListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "recipeToDescription", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeViewCell().identifier, for: indexPath) as? RecipeViewCell else {
            return UITableViewCell()
        }
        let recipe = recipes[indexPath.row].recipe
        
        cell.settingRecipeCell(recipe: recipe)
       
        return cell
    }
}
