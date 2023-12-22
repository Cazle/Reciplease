import Foundation

final class IngredientStore {
    
    var ingredients: [String] = []
    
    func add(ingredient: String) {
        ingredients.append(ingredient)
    }
    func deleteAll() {
        ingredients.removeAll()
    }
}
