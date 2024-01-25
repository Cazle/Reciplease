import UIKit

final class RecipeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    
    let identifier = "recipeCustomCell"
    let apiHandler = APIHandler()
    let formatAndTime = CaloriesAndTime()
    
    func nibRecipeViewCell() -> UINib {
        return UINib(nibName: "RecipeViewCell", bundle: nil)
    }
    
    func settingRecipeCell(recipe: Recipe) {
        let getCalories = recipe.calories
        
        guard let cookingTime = recipe.totalTime else { return }
        
        let getIngredients = recipe.ingredients
        let ingredients = getIngredients.map {$0.food}.joined(separator: ", ")
        
        let regularImage = recipe.images.regular.url
        guard let urlImage = URL(string: regularImage) else {return}
        
        nameLabel.text = recipe.label
        caloriesLabel.text = formatAndTime.formattingCalories(getCalories)
        timeLabel.text = formatAndTime.formatingHoursAndMinutes(time: cookingTime)
        
        ingredientLabel.text = ingredients
        
        apiHandler.request(url: urlImage) {data, response in
            guard let data = data else { return }
            let image = UIImage(data: data)
            self.mealImageView.image = image
        }
        
        nameLabel.accessibilityLabel = recipe.label
        ingredientLabel.accessibilityLabel = "Ingredients :\(recipe.ingredients.map{$0.food})"
        caloriesLabel.accessibilityLabel = "Number of calories: \(recipe.calories)"
        timeLabel.accessibilityLabel = "Time needed for recipe: \(recipe.totalTime ?? 0)"
    }
    
    func settingFavoriteCell(recipe: RecipeEntity) {
        guard let getIngredients = recipe.ingredients else {
            return
        }
        let time = Int(recipe.time)
        let ingredients = getIngredients.map {$0}.joined(separator: ", ")
        
        nameLabel.text = recipe.name
        ingredientLabel.text = ingredients
        caloriesLabel.text = formatAndTime.formattingCalories(recipe.calories)
        timeLabel.text = formatAndTime.formatingHoursAndMinutes(time: time)
        
        nameLabel.accessibilityLabel = recipe.name
        ingredientLabel.accessibilityLabel = ingredients
        caloriesLabel.accessibilityLabel = String(recipe.calories)
        timeLabel.accessibilityLabel = String(recipe.time)
        
        guard let regularImage = recipe.urlImage else {
            return
        }
        guard let urlImage = URL(string: regularImage) else {
            return
        }
        apiHandler.request(url: urlImage) {data, response in
            guard let data = data else { return }
            let image = UIImage(data: data)
            self.mealImageView.image = image
        }
    }
}

