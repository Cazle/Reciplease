import UIKit
import Alamofire

final class SearchController: UIViewController {
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let ingredientStore = IngredientStore()
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
        
        // TODO: Handling user input
    }
    @IBAction func tapClear(_ sender: Any) {
        ingredientStore.ingredients = []
        tableView.reloadData()
    }
    
    @IBAction func tapSearch(_ sender: Any) {
        let url = urlEndpoint.URLRecipe(with: ingredientStore.ingredients)
        apiHandler.request(url: url) { result in
            switch result {
            case .success(let data):
                let recipe = data.hits[0]
                
            case .failure(_):
                
                // TODO: Method to handle error
                return
            }
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

