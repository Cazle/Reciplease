import UIKit

final class IngredientViewCell: UITableViewCell {
    
    @IBOutlet weak var IngredientNameLabel: UILabel!
    
    func settingCell(ingredient: String) {
        IngredientNameLabel.text = "- " + ingredient
    }
}
