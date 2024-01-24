import UIKit
import Alamofire

final class SearchController: UIViewController {
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    let ingredientStore = IngredientStore()
    let recipeHandler = DecodingRecipeModel()
    let urlEndpoint = URLEndpoint()
    var recipes = [Hit]()
    var receivedNextLink: Next?
    
    let cellIdentifier = "ingredientCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeAccessibilityComponents()
        
        tableView.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
                view.addGestureRecognizer(tap)
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
    }
    
    private func makeAccessibilityComponents() {
        searchBarTextField.accessibilityLabel = "Searching bar to enter your ingredients"
        searchBarTextField.accessibilityIdentifier = "searchBarTextField"
        
        tableView.accessibilityLabel = "List of all your ingredients"
        tableView.accessibilityIdentifier = "tableView"
        
        errorLabel.accessibilityLabel = "Error, there is something wrong with your ingredients, make sure to enter correct ingredient."
        errorLabel.accessibilityIdentifier = "errorLabel"
        
        searchButton.accessibilityLabel = "Button for searching recipes"
        searchButton.accessibilityIdentifier = "searchButton"
    }
    
    @IBAction func tapAdd(_ sender: Any) {
        guard let input = searchBarTextField.text else { return }
        ingredientStore.add(ingredient: input)
        searchBarTextField.text = ""
        tableView.reloadData()
    }
    
    @IBAction func tapClear(_ sender: Any) {
        ingredientStore.deleteAll()
        tableView.reloadData()
    }
    
    @IBAction func tapSearch(_ sender: Any) {
        self.errorLabel.isHidden = true
        let url = urlEndpoint.urlRecipe(with: ingredientStore.ingredients)
        recipeHandler.requestRecipe(url: url) {[weak self] response in
            switch response {
            case .success(let data):
                self?.recipes = data.hits
                self?.receivedNextLink = data.links.next
                if data.hits.isEmpty {
                    self?.errorLabel.isHidden = false
                } else {
                    self?.performSegue(withIdentifier: "searchToRecipe", sender: self)
                }
            case .failure:
                self?.errorLabel.isHidden = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "searchToRecipe") {
            if let recipeController = (segue.destination as? RecipeListController) {
                recipeController.recipes = recipes
                recipeController.nextLink = receivedNextLink
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

