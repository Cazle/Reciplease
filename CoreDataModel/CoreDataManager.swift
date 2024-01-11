import Foundation
import CoreData

final class CoreDataManager {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addingNewRecipe(recipe: Recipe?, name: String, calories: Double, time: Int?, url: String, urlImage: String?, ingredients: [String], ingredientLines: [String]) -> RecipeEntity {
        
        let newRecipe = RecipeEntity(context: context)
        if let receivedTime = time, let receivedUrlImage = urlImage {
            newRecipe.name = name
            newRecipe.calories = calories
            newRecipe.time = Int32(receivedTime)
            newRecipe.urlImage = receivedUrlImage
            newRecipe.ingredientLines = ingredientLines
            newRecipe.ingredients = ingredients
            newRecipe.url = url
        }
        return newRecipe
    }
}
