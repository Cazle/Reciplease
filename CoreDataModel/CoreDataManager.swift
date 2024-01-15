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
    func fetchRecipes(completion: @escaping ([RecipeEntity]?) -> Void) {
            do {
                let recipes = try context.fetch(RecipeEntity.fetchRequest()) as? [RecipeEntity]
                completion(recipes)
            } catch {
                print("Failed retrieving data: \(error)")
                completion(nil)
            }
        }
    func deletingRecipe(deleting: RecipeEntity) {
        self.context.delete(deleting)
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

