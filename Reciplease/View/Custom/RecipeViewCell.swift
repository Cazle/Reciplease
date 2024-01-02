import UIKit

final class RecipeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    
    let imageHandler = ImageHandler()
    let identifier = "recipeCustomCell"
    
    func nib() -> UINib {
        return UINib(nibName: "RecipeViewCell", bundle: nil)
    }
    
    func settingRecipeCell(recipe: Recipe) {
        settingLikesAndTime()
        settingImageView(recipe: recipe)
        settingNameAndIngredients(recipe: recipe)
    }
    private func settingLikesAndTime() {
        let randomLikes = [" 120 👍", " 135 👍", " 1,5k 👍", " 335 👍", 
                           " 1,3k 👍", " 2,9k 👍", " 13 👍", " 3,7k 👍"]
        let randomTimeCook = ["20m ⏱️", "1h15 ⏱️", "45min ⏱️", "35m ⏱️",
                              "50mm ⏱️", "10m ⏱️", "2h ⏱️", "1h30 ⏱️"]
        likesLabel.text = randomLikes.randomElement()
        timeLabel.text = randomTimeCook.randomElement()
    }
    
    private func settingImageView(recipe: Recipe) {
        let regularImage = recipe.images.regular.url
        guard let urlImage = URL(string: regularImage) else {
            return
        }
        imageHandler.requestImage(url: urlImage) {response in
            DispatchQueue.main.async {
                switch response {
                case .success (let data):
                    guard let image = UIImage(data: data) else {
                        return
                    }
                    self.mealImageView.image = image
                case .failure:
                    self.mealImageView.image = nil
                }
            }
        }
    }
    func settingNameAndIngredients(recipe: Recipe) {
        nameLabel.text = recipe.label
        
        let getIngredients = recipe.ingredients
        let ingredients = getIngredients.map {$0.food}.joined(separator: ", ")
        ingredientLabel.text = ingredients
    }
}
