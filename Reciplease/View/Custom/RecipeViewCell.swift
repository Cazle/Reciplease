import UIKit

final class RecipeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    
    let imageHandler = ImageHandler()
    let identifier = "recipeCustomCell"
    
    func nib() -> UINib {
        return UINib(nibName: "RecipeViewCell", bundle: nil)
    }
    
    func settingRecipeCell(recipe: Recipe) {
        nameLabel.text = recipe.label
        
        let getIngredients = recipe.ingredients
        let ingredients = getIngredients.map {$0.food}.joined(separator: ", ")
        ingredientLabel.text = ingredients
        
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
}
