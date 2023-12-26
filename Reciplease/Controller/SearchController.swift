import UIKit
import Alamofire

final class SearchController: UIViewController {
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    let ingredientStore = IngredientStore()
    let apiHandler = APIHandler()
    let urlEndpoint = URLEndpoint()
    var recipes = [Hit]()
    
    let cellIdentifier = "ingredientCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    @IBAction func tapAdd(_ sender: Any) {
        guard let input = searchBarTextField.text else { return }
        ingredientStore.add(ingredient: input)
        tableView.reloadData()
    }
    @IBAction func tapClear(_ sender: Any) {
        ingredientStore.deleteAll()
        tableView.reloadData()
    }
    
    @IBAction func tapSearch(_ sender: Any) {
        self.errorLabel.isHidden = true
        let url = urlEndpoint.urlRecipe(with: ingredientStore.ingredients)
        apiHandler.request(url: url) { result in
            guard case let .success(data) = result else {
                self.errorLabel.isHidden = false
                return
            }
                self.recipes = data.hits
                if self.recipes.isEmpty {
                    self.errorLabel.isHidden = false
                } else {
                    self.performSegue(withIdentifier: "callSucceed", sender: self)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "callSucceed") {
            let recipeController = (segue.destination as! RecipeListController)
            recipeController.recipes = recipes
        }
    }
}

extension SearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientStore.ingredients.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IngredientViewCell else {
            return UITableViewCell()
        }
        let ingredient = ingredientStore.ingredients[indexPath.row]
        cell.settingCell(ingredient: ingredient)
        return cell
    }
}

