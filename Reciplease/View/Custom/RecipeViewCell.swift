import UIKit

final class RecipeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var cellView: UIView!
    
    func settingRecipeCell(name: String, ingredients: String) {
        nameLabel.text = name
        ingredientLabel.text = ingredients
    }
    func settingTheImage(image: String) {
        guard let urlImage = URL(string: image) else {return}
        self.mealImageView.af.setImage(withURL: urlImage)
    }
    func customizingTheCell() {
        mealImageView.layer.masksToBounds = false
        mealImageView.backgroundColor = .clear
        mealImageView.layer.shadowColor = UIColor.black.cgColor
        mealImageView.layer.shadowOffset = CGSize(width: 10, height: 10)
        mealImageView.layer.opacity = 1
        mealImageView.layer.shadowRadius = 5
    }
}
