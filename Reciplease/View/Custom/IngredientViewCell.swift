import UIKit

final class IngredientViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientNameLabel: UILabel!
    
    func settingCell(ingredient: String) {
        ingredientNameLabel.text = "- " + ingredient
        ingredientNameLabel.accessibilityLabel = ingredient
        ingredientNameLabel.accessibilityValue = ingredient
    }
}
