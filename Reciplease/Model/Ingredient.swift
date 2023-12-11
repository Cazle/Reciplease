import Foundation

final class Ingredient {
    
    var ListOfIngredients: [String] = []
    
    static let shared = Ingredient()
    
    private init() {}
    
    func add(ingredient: String) {
        ListOfIngredients.append(ingredient)
    }
}
