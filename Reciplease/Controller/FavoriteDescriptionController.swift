import Foundation
import UIKit

final class FavoriteDescriptionController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var starButton: UIBarButtonItem!
    @IBOutlet weak var websiteButton: UIButton!
    
    let cellIdentifier = "favoriteCell"
    
    var selectedRecipe: RecipeEntity?
    var storedRecipes: [RecipeEntity]?
    let formatAndTime = CaloriesAndTime()
    let apiHandler = APIHandler()
    let coreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        backButton()
        settingDescription()
        makeAccessibilityComponents()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchingRecipes()
        loadTheRecipeToDeleteIt()
    }
    
    func backButton() {
        let leftButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(tapBackButton))
        navigationItem.leftBarButtonItem = leftButton
        leftButton.tintColor = .white
    }
    
    @objc func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func makeAccessibilityComponents() {
        guard let recipe = selectedRecipe else { return }
        
        nameLabel.accessibilityLabel = "Name of the recipe"
        nameLabel.accessibilityValue = recipe.name
        
        timeLabel.accessibilityLabel = "Preparation time of the recipe"
        timeLabel.accessibilityValue = String(recipe.time)
        
        caloriesLabel.accessibilityLabel = "Calories of the recipe"
        caloriesLabel.accessibilityValue = String(recipe.calories)
        
        mealImageView.accessibilityLabel = "Image of the recipe"
        mealImageView.accessibilityTraits = .image
        
        starButton.accessibilityLabel = "Button to delete"
        starButton.accessibilityTraits = .button
        starButton.accessibilityHint = "Tap to delete the current recipe"
        
        websiteButton.accessibilityLabel = "Go to recipe website"
        websiteButton.accessibilityTraits = .button
        websiteButton.accessibilityHint = "Tap to go on the recipe website"
    }
    
    func fetchingRecipes() {
        do {
            try storedRecipes = coreDataManager.fetchingRecipes()
        } catch {
            presentAlert(message: "An error occured")
        }
        
    }
    
    func loadTheRecipeToDeleteIt() {
        guard let name = selectedRecipe?.name else { return }
        selectedRecipe = coreDataManager.loadTheCurrentRecipeFromTheStore(recipeName: name)
    }
    
    func settingDescription() {
        guard let time = selectedRecipe?.time else { return }
        guard let calories = selectedRecipe?.calories else { return }
        guard let urlImage = selectedRecipe?.urlImage else { return }
        guard let url = URL(string: urlImage) else { return }
        
        nameLabel.text = selectedRecipe?.name
        timeLabel.text = formatAndTime.formatingHoursAndMinutes(time: Int(time))
        caloriesLabel.text = formatAndTime.formattingCalories(calories)
        
        apiHandler.request(url: url) {[weak self] data, response in
            guard let data = data else { return }
            let image = UIImage(data: data)
            self?.mealImageView.image = image
        }
    }
    
    @IBAction func deletingRecipe(_ sender: Any) {
        guard let recipeToDelete = selectedRecipe else {
            return
        }
        coreDataManager.deletingRecipe(deleting: recipeToDelete)
        
        do {
            try coreDataManager.savingContext()
        } catch {
            presentAlert(message: "An error occured")
        }
        
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
