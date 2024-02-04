import Foundation
import CoreData

final class CoreDataManager {
    
    let context: NSManagedObjectContext
    
    
    init(context: NSManagedObjectContext = AppDelegate().backgroundContext) {
        self.context = context
    }
    
    func addingNewRecipe(recipe: Recipe?, name: String, calories: Double, time: Int?, url: String, urlImage: String?, ingredients: [String], ingredientLines: [String]) -> RecipeEntity {
        
        context.performAndWait {
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
    
    func fetchingRecipes() throws -> [RecipeEntity] {
        try context.performAndWait {
            try context.fetch(RecipeEntity.fetchRequest())
        }
    }
    
    func deletingRecipe(deleting: RecipeEntity) {
        context.performAndWait {
            context.delete(deleting)
        }
    }
    
    func savingContext() throws {
        try context.performAndWait {
            try context.save()
        }
    }
    
    func checkingIfRecipeIsAlreadyInFavorites(nameOfRecipe: String) -> Bool {
        var isExisting = false
        
         context.performAndWait {
            let fetchRequest = RecipeEntity.fetchRequest()
            let predicate = NSPredicate(format: "name == %@", nameOfRecipe)
            fetchRequest.predicate = predicate
             if let fetchingNames = try? context.fetch(fetchRequest) {
                 isExisting = !fetchingNames.isEmpty
             }
        }
        return isExisting
    }
    
    func loadTheCurrentRecipeFromTheStore(recipeName: String) -> RecipeEntity? {
        var recipeEntity: RecipeEntity?
        
            context.performAndWait {
                
                let fetchRequest = RecipeEntity.fetchRequest()
                let predicate = NSPredicate(format: "name == %@", recipeName)
                fetchRequest.predicate = predicate
                
                if let fetchedRecipes = try? context.fetch(fetchRequest) {
                    recipeEntity = fetchedRecipes.first
                }
            }
            return recipeEntity
    }
}
        
