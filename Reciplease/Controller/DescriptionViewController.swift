import Foundation
import UIKit

final class DescriptionViewController: UIViewController {
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var receivedRecipe: Recipe?
    
    let cellIdentifier = "descriptionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func settingImage() {
        
    }

}
extension DescriptionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredient = receivedRecipe?.ingredientLines else {
            return 0
        }
        return ingredient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DescriptionViewCell else {
            return UITableViewCell()
        }
        
        guard let ingredientList = receivedRecipe?.ingredientLines else {
            cell.errorCalled(error: "Something went wrong.")
            return cell
        }
        let allIngredients = ingredientList[indexPath.row]
        cell.settingCell(ingredient: allIngredients)
        
        return cell
    }
}
