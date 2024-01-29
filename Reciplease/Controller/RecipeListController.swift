import Foundation
import UIKit

final class RecipeListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barNavigation: UINavigationItem!
    @IBOutlet weak var spinLoader: UIActivityIndicatorView!
    
    
    var recipes = [Hit]()
    var selectedRecipe: Recipe?
    let decodingCall = DecodingRecipeModel()
    var nextLink: Next?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        tableView.register(RecipeViewCell().nibRecipeViewCell(), forCellReuseIdentifier: RecipeViewCell().identifier)
        makeAccessibilityComponents()
    }
    
    func makeAccessibilityComponents() {
        tableView.accessibilityLabel = "All recipes searched"
        barNavigation.leftBarButtonItem?.accessibilityLabel = "Back button"
        spinLoader.accessibilityLabel = "Spin loader who appears when recipe are loading"
    }
    
    func backButton() {
        let leftButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(tapBackButton))
        navigationItem.leftBarButtonItem = leftButton
        leftButton.tintColor = .white
        leftButton.accessibilityLabel = "Back Button"
    }
    
    @objc func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "recipeToDescription", let descriptionController = segue.destination as? DescriptionViewController else { return }
        descriptionController.receivedRecipe = selectedRecipe
    }
}

extension RecipeListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = recipes[indexPath.row].recipe
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == recipes.count - 1  {
            
            spinLoader.hidesWhenStopped = true
            spinLoader.startAnimating()
            
            guard let urlNext = nextLink?.href, let url = URL(string: urlNext) else { return }
            
            decodingCall.requestRecipe(url: url) {response in
                switch response {
                case let .success(newHit):
                    self.nextLink = newHit.links.next
                    self.recipes.append(contentsOf: newHit.hits)
                    self.tableView.reloadData()
                    self.spinLoader.stopAnimating()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
