import Foundation
import UIKit

final class DescriptionViewController: UIViewController {
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var receivedRecipe = [Hit]()
    
    let cellIdentifier = "descriptionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(receivedRecipe, "JE SUIS LE DESCRIPTION CONTROLLER")
    }
    func settingImage() {
        
    }

}
extension DescriptionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        receivedRecipe.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DescriptionViewCell else {
            return UITableViewCell()
        }
        let recipe = receivedRecipe[indexPath.row].recipe
        let ingredients = recipe.ingredientLines
        cell.settingCell(ingredient: ingredients)
        
        return cell
    }
}
