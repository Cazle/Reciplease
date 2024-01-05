import Foundation
import UIKit

final class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let apiHandler = APIHandler()
    let formatAndTime = FormatAndTime()
    var receivedRecipe: Recipe?
    
    let cellIdentifier = "descriptionCell"
    
    override func viewDidLoad() {
        settingName()
        settingImage()
        settingLikes()
        settingTime()
    }
    func settingName() {
        nameLabel.text = receivedRecipe?.label
    }
    func settingImage() {
        guard let receivedImage = receivedRecipe?.images.regular.url else {
            return
        }
        guard let urlImage = URL(string: receivedImage) else {
            return
        }
        apiHandler.request(url: urlImage) {response in
            switch response {
            case let .success((data, _)):
                let image = UIImage(data: data)
                self.mealImageView.image = image
            case .failure :
                self.mealImageView.image = nil
            }
        }
    }
    func settingLikes() {
        guard let receivedlikes = receivedRecipe?.calories else {
            return
        }
        likesLabel.text = formatAndTime.formattingLikes(receivedlikes) + " 👍"
    }
    func settingTime() {
        guard let timeCooking = receivedRecipe?.totalTime else {
            return
        }
        timeLabel.text = formatAndTime.formatingHoursAndMinutes(minutes: timeCooking)
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
