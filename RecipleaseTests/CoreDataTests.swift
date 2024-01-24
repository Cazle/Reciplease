import Foundation
import CoreData
import XCTest
@testable import Reciplease

final class CoreDataTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        loadingFakeCoreData()
    }
    override func tearDown() {
        coreDataManager = nil
    }
    
    func loadingFakeCoreData() {
        let container = NSPersistentContainer(name: "Reciplease")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (_, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
        
        let backgroundContext = container.newBackgroundContext()
        coreDataManager = CoreDataManager(context: backgroundContext)
    }
    
    func test_fetchingRecipe() throws {
        let _ = coreDataManager.addingNewRecipe(recipe: nil, name: "Chicken", calories: 800, time: 30, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["Chicken and curry"], ingredientLines: ["300G OF CHICKEN, 300G OF CURRY"])
        
        let _ = coreDataManager.addingNewRecipe(recipe: nil, name: "Curry", calories: 700, time: 45, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["curry"], ingredientLines: ["300G OF CURRY"])
        
        try coreDataManager.context.save()
       
        
        do {
            let fetchedRecipe = try coreDataManager.fetchingRecipes()
            XCTAssertEqual(fetchedRecipe.count, 2)
        } catch {
            XCTFail("Did not fetched")
        }
    }
    
    func test_addingANewRecipe() {
        
        let _ = coreDataManager.addingNewRecipe(recipe: nil, name: "Chicken", calories: 800, time: 30, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["Chicken and curry"], ingredientLines: ["300G OF CHICKEN, 300G OF CURRY"])
        do {
            try coreDataManager.context.save()
        } catch {}
        
        do {
            let fetchedRecipe = try coreDataManager.fetchingRecipes()
            XCTAssertEqual(fetchedRecipe.first?.name, "Chicken")
            XCTAssertEqual(fetchedRecipe.first?.time, 30)
            XCTAssertEqual(fetchedRecipe.first?.url, "URL RECIPE")
            XCTAssertEqual(fetchedRecipe.first?.urlImage, "URL IMAGE")
            XCTAssertEqual(fetchedRecipe.first?.ingredients, ["Chicken and curry"])
            XCTAssertEqual(fetchedRecipe.first?.ingredientLines, ["300G OF CHICKEN, 300G OF CURRY"])
        } catch {}
    }
    func test_deletingARecipe() {
        let newRecipe = coreDataManager.addingNewRecipe(recipe: nil, name: "Chicken", calories: 800, time: 30, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["Chicken and curry"], ingredientLines: ["300G OF CHICKEN, 300G OF CURRY"])
        
        do {
            try coreDataManager.context.save()
        } catch {}
        
        coreDataManager.deletingRecipe(deleting: newRecipe)
        
        do {
            let fetchedRecipe =  try coreDataManager.fetchingRecipes()
            XCTAssertEqual(fetchedRecipe, [])
        } catch {}
    }
    func test_checkingIfARecipeNameAlreadyExists() {
        let _ = coreDataManager.addingNewRecipe(recipe: nil, name: "Chicken", calories: 800, time: 30, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["Chicken and curry"], ingredientLines: ["300G OF CHICKEN, 300G OF CURRY"])
        
        do {
            try coreDataManager.context.save()
        } catch {}
        
        do {
           let recipeExists =  coreDataManager.checkingIfRecipeIsAlreadyInFavorites(nameOfRecipe: "Chicken")
            XCTAssertTrue(recipeExists)
        }
    }
    func test_nameOfRecipeDoesNotExists() {
        let _ = coreDataManager.addingNewRecipe(recipe: nil, name: "Chicken", calories: 800, time: 30, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["Chicken and curry"], ingredientLines: ["300G OF CHICKEN, 300G OF CURRY"])
        
        do {
            try coreDataManager.context.save()
        } catch {}
        
        do {
           let recipeDoesNotExists =  coreDataManager.checkingIfRecipeIsAlreadyInFavorites(nameOfRecipe: "Tomato")
            XCTAssertFalse(recipeDoesNotExists)
        }
    }
}
