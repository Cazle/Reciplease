import Foundation
import CoreData
import UIKit

final class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recipeWebsiteButton: UIButton!
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let apiHandler = APIHandler()
    let formatAndTime = FormatAndTime()
    var receivedRecipe: Recipe?
    var recipesStored: [RecipeData]?
    
    let cellIdentifier = "descriptionCell"
    
    override func viewDidLoad() {
        settingName()
        settingImage()
        settingLikes()
        settingTime()
        setStarIcon()
        
    }
    
    @IBAction func handlingStoredRecipe(_ sender: Any) {
        guard let likes = receivedRecipe?.calories, 
                let name = receivedRecipe?.label,
                let time = receivedRecipe?.totalTime,
                let ingredientsLines = receivedRecipe?.ingredientLines,
                let ingredients = receivedRecipe?.ingredients,
                let urlImage = receivedRecipe?.images.regular.url,
                let url = receivedRecipe?.url else {
            return
        }
        let newRecipe = RecipeData(context: context)
        newRecipe.likes = likes
        newRecipe.name = name
        newRecipe.time = Int32(time)
        newRecipe.ingredientLines = ingredientsLines
        newRecipe.ingredients = ingredients.map {$0.food}
        newRecipe.urlImage = urlImage
        newRecipe.url = url
        
        do {
            print(newRecipe)
            try context.save()
            setStarIcon()
        } catch {
            print("Something went wrong")
            print("Error saving recipe to CoreData: \(error.localizedDescription)")
        }
    }
    
    
    func setStarIcon() {
        let star = UIImage(systemName: "star")
        let starFilled = UIImage(systemName: "star.fill")
        if starButton.image == star {
            starButton.image = starFilled
        } else {
            starButton.image = star
        }
    }
    @IBAction func goToRecipeWebSite(_ sender: Any) {
        guard let receivedUrl = receivedRecipe?.url else {
            return
        }
        guard let url = URL(string: receivedUrl) else {
            return
        }
        UIApplication.shared.open(url)
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
        likesLabel.text = formatAndTime.formattingLikes(receivedlikes)
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
