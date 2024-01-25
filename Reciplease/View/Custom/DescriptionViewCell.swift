import Foundation
import UIKit

final class DescriptionViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientLabel: UILabel!
    
    func settingCell(ingredient: String) {
        ingredientLabel.text = "- " + ingredient
        ingredientLabel.accessibilityLabel = ingredient
    }
    
    func errorCalled(error: String) {
        ingredientLabel.text = error
    }
}
