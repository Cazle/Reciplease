import Foundation
import UIKit

final class DescriptionFavoriteViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientLabel: UILabel!
    
    func settingIngredient(named: String) {
        ingredientLabel.text = "- " + named
    }
    
}
