import UIKit

final class RecipeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    
    func settingRecipeCell(name: String, ingredients: String) {
        nameLabel.text = name
        ingredientLabel.text = ingredients
    }
    func settingTheImage(url: String) {
        guard let urlImage = URL(string: url) else {return}
        self.mealImageView.af.setImage(withURL: urlImage)
    }
}
