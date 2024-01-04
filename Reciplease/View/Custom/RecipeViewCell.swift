import UIKit

final class RecipeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    
    let identifier = "recipeCustomCell"
    let apiHandler = APIHandler()
    
    func nib() -> UINib {
        return UINib(nibName: "RecipeViewCell", bundle: nil)
    }
    
    func settingRecipeCell(recipe: Recipe) {
        settingLikes(recipe: recipe)
        settingImageView(recipe: recipe)
        settingNameAndIngredients(recipe: recipe)
        settingTime(recipe: recipe)
    }
    private func settingLikes(recipe: Recipe) {
        let getLikes = recipe.calories
        likesLabel.text = formattingLikes(getLikes) + " 👍"
        
    }
    private func settingTime(recipe: Recipe) {
        guard let cookingTime = recipe.totalTime else {
            return
        }
        let (hours, minutes) = minutesToHoursAndMinutes(cookingTime)
        switch (hours, minutes) {
        case (0, 0):
            timeLabel.text = ""
        case (1...24, 0):
            timeLabel.text = "\(hours)h ⏱️"
        case (0, 0...60):
            timeLabel.text = "\(minutes)m ⏱️"
        case (1...10, 0...60):
            timeLabel.text = "\(hours)h\(minutes)m ⏱️"
        default:
            timeLabel.text = "Error"
        }
    }
    private func formattingLikes(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        
        if number < 1000 {
            let convertIntoInt = Int(number)
            return formatter.string(from: NSNumber(value: convertIntoInt)) ?? ""
        } else {
            let formatedNumber = number / 1000.0
            return "\(formatter.string(from: NSNumber(value: formatedNumber)) ?? "")k"
        }
    }
    private func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    
    private func settingImageView(recipe: Recipe) {
        let regularImage = recipe.images.regular.url
        guard let urlImage = URL(string: regularImage) else {
            return
        }
        apiHandler.request(url: urlImage) {response in
            switch response {
            case let .success((data, _)):
                let image = UIImage(data: data)
                self.mealImageView.image = image
            case .failure:
                self.mealImageView.image = nil
            }
        }
    }
    private func settingNameAndIngredients(recipe: Recipe) {
        nameLabel.text = recipe.label
        
        let getIngredients = recipe.ingredients
        let ingredients = getIngredients.map {$0.food}.joined(separator: ", ")
        ingredientLabel.text = ingredients
    }
}
