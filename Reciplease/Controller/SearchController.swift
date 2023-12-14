import UIKit
import Alamofire

final class SearchController: UIViewController {
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let ingredientStore = Ingredient()
    let apiHandler = APIHandler()
    let urlEndpoint = URLEndpoint()
    
    let cellIdentifier = "IngredientCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.dataSource = self
    }
    
    
    @IBAction func tapAdd(_ sender: Any) {
        guard let input = searchBarTextField.text else { return }
        ingredientStore.add(ingredient: input)
        tableView.reloadData()
    }
    @IBAction func tapClear(_ sender: Any) {
        ingredientStore.ingredients = []
        tableView.reloadData()
    }
    
    @IBAction func tapSearch(_ sender: Any) {
        let url = urlEndpoint.URLRecipe(of: ingredientStore.ingredients)
        apiHandler.request(url: url)
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

