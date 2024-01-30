import Foundation
import CoreData
import UIKit

final class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starButton: UIBarButtonItem!
    @IBOutlet weak var websiteButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).backgroundContext
    
    let apiHandler = APIHandler()
    let formatAndTime = CaloriesAndTime()
    var receivedRecipe: Recipe?
    var storedRecipes: [RecipeEntity]?
    var currentRecipe: RecipeEntity?
    lazy var coreDataManager = CoreDataManager(context: context)
    
    let cellIdentifier = "descriptionCell"
    
    override func viewDidLoad() {
        backButton()
        settingName()
        settingImage()
        settingCalories()
        settingTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchingAllRecipes()
        checkIfRecipeIsInFavorites()
        loadRecipeEntityIfItExistsInTheStore()
    }
    
    func makeAccessibilityComponents() {
        guard let recipe = receivedRecipe else { return }
        guard let time = recipe.totalTime else { return }
        
        timeLabel.accessibilityLabel = "Preparation time of the recipe"
        timeLabel.accessibilityValue = String(time)
        
        caloriesLabel.accessibilityLabel = "Calories of the recipe"
        caloriesLabel.accessibilityValue = String(recipe.calories)
        
        nameLabel.accessibilityLabel = "Name of the recipe"
        nameLabel.accessibilityValue = recipe.label
        
        mealImageView.accessibilityLabel = "Image of the recipe"
        mealImageView.accessibilityTraits = .image
        
        starButton.accessibilityLabel = "Button to add or delete a recipe to favorite"
        starButton.accessibilityTraits = .button
        
        websiteButton.accessibilityLabel = "Go to the recipe website"
        websiteButton.accessibilityTraits = .button
    }
    
    func backButton() {
        let leftButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(tapBackButton))
        navigationItem.leftBarButtonItem = leftButton
        leftButton.tintColor = .white
        leftButton.accessibilityLabel = "Back button"
    }
    
    @objc func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func checkIfRecipeIsInFavorites() {
        guard let nameOfRecipe = receivedRecipe?.label else { return }
        if coreDataManager.checkingIfRecipeIsAlreadyInFavorites(nameOfRecipe: nameOfRecipe) {
            setStarIcon(to: "star.fill")
            starButton.accessibilityValue = "This recipe is already in favorite"
            starButton.accessibilityTraits = .selected
        } else {
            starButton.accessibilityValue = "This recipe is not in favorite"
            starButton.accessibilityTraits = .none
            setStarIcon(to: "star")
        }
    }
    
    func fetchingAllRecipes() {
        do {
            try storedRecipes = coreDataManager.fetchingRecipes()
        } catch {
            presentAlert(message: "Error occured. Failed to fetch recipes.")
        }
        
    }
    
    func loadRecipeEntityIfItExistsInTheStore() {
        guard let recipe = receivedRecipe else { return }
        guard let store = storedRecipes else { return }
        let allStore = store.map{$0.name}
        
        if allStore.contains(recipe.label) {
            guard let existingRecipe = store.first(where: {$0.name == recipe.label}) else { return }
            currentRecipe = existingRecipe
        }
    }
    
    @IBAction func handlingStoredRecipe(_ sender: Any) {
        guard let nameOfRecipe = receivedRecipe?.label else { return }
        
        if coreDataManager.checkingIfRecipeIsAlreadyInFavorites(nameOfRecipe: nameOfRecipe) {
            guard let deletingRecipe = currentRecipe else { return }
            coreDataManager.deletingRecipe(deleting: deletingRecipe)
            starButton.accessibilityValue = "Recipe is deleted from the favorites !"
            setStarIcon(to: "star")
        } else {
            setStarIcon(to: "star.fill")
            starButton.accessibilityValue = "Recipe is added to the favorites !"
            addRecipe()
        }
        fetchingAllRecipes()
    }
    
    func addRecipe() {
        guard let recipe = receivedRecipe else {
            return
        }
        let newRecipe = coreDataManager.addingNewRecipe(
            recipe: recipe,
            name: recipe.label,
            calories: recipe.calories,
            time: recipe.totalTime,
            url: recipe.url,
            urlImage: recipe.images.regular.url,
            ingredients: recipe.ingredients.map{$0.food},
            ingredientLines: recipe.ingredientLines)
        
            currentRecipe = newRecipe
        do {
            try context.save()
        } catch {
            presentAlert(message: "Error occured. Can't save the recipe.")
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
        
        apiHandler.request(url: urlImage) {data, response in
            guard let data = data else { return }
            let image = UIImage(data: data)
            self.mealImageView.image = image
        }
    }
    
    func settingCalories() {
        guard let receivedCalories = receivedRecipe?.calories else {
            return
        }
        caloriesLabel.text = formatAndTime.formattingCalories(receivedCalories)
    }
    
    func settingTime() {
        guard let timeCooking = receivedRecipe?.totalTime else {
            return
        }
        timeLabel.text = formatAndTime.formatingHoursAndMinutes(time: timeCooking)
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
