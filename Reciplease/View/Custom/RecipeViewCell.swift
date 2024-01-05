import UIKit

final class RecipeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    
    let identifier = "recipeCustomCell"
    let apiHandler = APIHandler()
    let formatAndTime = FormatAndTime()
    
    func nib() -> UINib {
        return UINib(nibName: "RecipeViewCell", bundle: nil)
    }
    
    func settingRecipeCell(recipe: Recipe) {
        settingLikes(recipe: recipe)
        settingImageView(recipe: recipe)
        settingNameAndIngredients(recipe: recipe)
        settingTime(recipe: recipe)
    }
    private func settingLikes(recipe: Recipe) {
        let getLikes = recipe.calories
        likesLabel.text = formatAndTime.formattingLikes(getLikes) + " 👍"
        
    }
    private func settingTime(recipe: Recipe) {
        guard let cookingTime = recipe.totalTime else {
            return
        }
        timeLabel.text = formatAndTime.formatingHoursAndMinutes(minutes: cookingTime)
    }
    private func settingImageView(recipe: Recipe) {
        let regularImage = recipe.images.regular.url
        guard let urlImage = URL(string: regularImage) else {
            return
        }
        apiHandler.request(url: urlImage) {response in
            switch response {
            case let .success((data, _)):
                let image = UIImage(data: data)
                self.mealImageView.image = image
            case .failure:
                self.mealImageView.image = nil
            }
        }
    }
    private func settingNameAndIngredients(recipe: Recipe) {
        nameLabel.text = recipe.label
        
        let getIngredients = recipe.ingredients
        let ingredients = getIngredients.map {$0.food}.joined(separator: ", ")
        ingredientLabel.text = ingredients
    }
}
