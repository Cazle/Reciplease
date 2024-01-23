import Foundation
import UIKit

final class FavoriteDescriptionController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    let cellIdentifier = "favoriteCell"
    
    var selectedRecipe: RecipeEntity?
    let formatAndTime = CaloriesAndTime()
    let apiHandler = APIHandler()
    let context = (UIApplication.shared.delegate as! AppDelegate).backgroundContext
    lazy var coreDataManager = CoreDataManager(context: context)
    
    override func viewDidLoad() {
       settingDescription()
    }
    
    func settingDescription() {
        guard let time = selectedRecipe?.time else { return }
        guard let calories = selectedRecipe?.calories else { return }
        guard let urlImage = selectedRecipe?.urlImage else { return }
        guard let url = URL(string: urlImage) else { return }
        
        nameLabel.text = selectedRecipe?.name
        timeLabel.text = formatAndTime.formatingHoursAndMinutes(time: Int(time))
        caloriesLabel.text = formatAndTime.formattingCalories(calories)
        
        apiHandler.request(url: url) {data, response in
            guard let data = data else { return }
            let image = UIImage(data: data)
            self.mealImageView.image = image
        }
    }
    @IBAction func deletingRecipe(_ sender: Any) {
        guard let recipeToDelete = selectedRecipe else {
            return
        }
        coreDataManager.deletingRecipe(deleting: recipeToDelete)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToRecipeWebsite(_ sender: Any) {
        guard let receivedUrl = selectedRecipe?.url else {
            return
        }
        guard let url = URL(string: receivedUrl) else {
            return
        }
        UIApplication.shared.open(url)
    }
}

extension FavoriteDescriptionController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = selectedRecipe else { return 0 }
        guard let ingredients = recipe.ingredientLines else { return 0 }
        return ingredients.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DescriptionFavoriteViewCell else {
            return UITableViewCell()
        }
        
        guard let recipe = selectedRecipe else {return UITableViewCell()}
        guard let ingredients = recipe.ingredientLines else {return UITableViewCell()}
        
        let listOfIngredients = ingredients[indexPath.row]
        cell.settingIngredient(named: listOfIngredients)
        
        return cell
        
    }
}
