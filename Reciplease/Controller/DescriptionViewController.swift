import Foundation
import CoreData
import UIKit

final class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starButton: UIBarButtonItem!
    @IBOutlet weak var warningLabel: UILabel!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).backgroundContext
    
    let apiHandler = APIHandler()
    let formatAndTime = FormatAndTime()
    var receivedRecipe: Recipe?
    var storedRecipes: [RecipeEntity]?
    lazy var coreDataManager = CoreDataManager(context: context)
    
    let cellIdentifier = "descriptionCell"
    
    override func viewDidLoad() {
        fetchingRecipe()
        checkingIfAlreadyInFavorites()
        settingName()
        settingImage()
        settingLikes()
        settingTime()
    }
    func checkingIfAlreadyInFavorites() {
        guard let stored = storedRecipes else { return }
        guard let nameOfRecipe = receivedRecipe?.label else { return }
        let nameStored = stored.map {$0.name}
        
        if nameStored.contains(nameOfRecipe) {
            setStarIcon(to: "star.fill")
        } else {
            setStarIcon(to: "star")
        }
    }
    func fetchingRecipe() {
        coreDataManager.fetchRecipes { recipes in
            self.storedRecipes = recipes
        }
    }
    
    @IBAction func handlingStoredRecipe(_ sender: Any) {
        guard let stored = storedRecipes else { return }
        guard let nameOfRecipe = receivedRecipe?.label else { return }
        let nameStored = stored.map {$0.name}
        
        if nameStored.contains(nameOfRecipe) {
            warningLabel.text = "THIS RECIPE IS ALREADY IN THE FAVORITES !"
            warningLabel.isHidden = false
        } else {
            addRecipe()
            fetchingRecipe()
        }
    }
    
    func addRecipe() {
        guard let recipe = receivedRecipe else {
            return
        }
        let _ = coreDataManager.addingNewRecipe(
            recipe: recipe,
            name: recipe.label,
            calories: recipe.calories,
            time: recipe.totalTime,
            url: recipe.url,
            urlImage: recipe.images.regular.url,
            ingredients: recipe.ingredients.map{$0.food},
            ingredientLines: recipe.ingredientLines)
        
        do {
            try context.save()
            setStarIcon(to: "star.fill")
            
        } catch {
            print("Something went wrong")
        }
    }
    
    
    func setStarIcon(to named: String) {
        starButton.image = UIImage(systemName: named)
    }
    @IBAction func goToRecipeWebSite(_ sender: Any) {
        guard let receivedUrl = receivedRecipe?.url else {
            return
        }
        guard let url = URL(string: receivedUrl) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func settingName() {
        nameLabel.text = receivedRecipe?.label
    }
    
    func settingImage() {
        guard let receivedImage = receivedRecipe?.images.regular.url else {
            return
        }
        guard let urlImage = URL(string: receivedImage) else {
            return
        }
        apiHandler.request(url: urlImage) {response in
            switch response {
            case let .success((data, _)):
                let image = UIImage(data: data)
                self.mealImageView.image = image
            case .failure :
                self.mealImageView.image = nil
            }
        }
    }
    
    func settingLikes() {
        guard let receivedlikes = receivedRecipe?.calories else {
            return
        }
        likesLabel.text = formatAndTime.formattingLikes(receivedlikes)
    }
    
    func settingTime() {
        guard let timeCooking = receivedRecipe?.totalTime else {
            return
        }
        timeLabel.text = formatAndTime.formatingHoursAndMinutes(minutes: timeCooking)
    }
}
extension DescriptionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredient = receivedRecipe?.ingredientLines else {
            return 0
        }
        return ingredient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DescriptionViewCell else {
            return UITableViewCell()
        }
        
        guard let ingredientList = receivedRecipe?.ingredientLines else {
            cell.errorCalled(error: "Something went wrong.")
            return cell
        }
        let allIngredients = ingredientList[indexPath.row]
        cell.settingCell(ingredient: allIngredients)
        
        return cell
    }
}
