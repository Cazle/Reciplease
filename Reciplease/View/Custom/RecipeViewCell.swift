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
        settingLikes(recipe: recipe)
        settingImageView(recipe: recipe)
        settingNameAndIngredients(recipe: recipe)
        settingTime(recipe: recipe)
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
    
    private func settingLikes(recipe: Recipe) {
        let getLikes = recipe.calories
        caloriesLabel.text = formatAndTime.formattingCalories(getLikes)
    }
    
    private func settingTime(recipe: Recipe) {
        guard let cookingTime = recipe.totalTime else {
            return
        }
        timeLabel.text = formatAndTime.formatingHoursAndMinutes(time: cookingTime)
    }
    
    private func settingImageView(recipe: Recipe) {
        let regularImage = recipe.images.regular.url
        guard let urlImage = URL(string: regularImage) else {
            return
        }
        apiHandler.request(url: urlImage) {data, response in
            guard let data = data else { return }
            let image = UIImage(data: data)
            self.mealImageView.image = image
        }
    }
    
    private func settingNameAndIngredients(recipe: Recipe) {
        nameLabel.text = recipe.label
        
        let getIngredients = recipe.ingredients
        let ingredients = getIngredients.map {$0.food}.joined(separator: ", ")
        ingredientLabel.text = ingredients
    }
}

