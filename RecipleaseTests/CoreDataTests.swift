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
    
    func test_fetchingRecipe() {
        let _ = coreDataManager.addingNewRecipe(recipe: nil, name: "Chicken", calories: 800, time: 30, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["Chicken and curry"], ingredientLines: ["300G OF CHICKEN, 300G OF CURRY"])
        
        let _ = coreDataManager.addingNewRecipe(recipe: nil, name: "Curry", calories: 700, time: 45, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["curry"], ingredientLines: ["300G OF CURRY"])
        
        try? coreDataManager.context.save()
       
        guard let fetchedRecipe = try? coreDataManager.fetchingRecipes() else { return }
        XCTAssertEqual(fetchedRecipe.count, 2)
    }
    
    func test_addingANewRecipe() {
        
        let _ = coreDataManager.addingNewRecipe(recipe: nil, name: "Chicken", calories: 800, time: 30, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["Chicken and curry"], ingredientLines: ["300G OF CHICKEN, 300G OF CURRY"])
        
        try? coreDataManager.context.save()
       
        
        guard let fetchedRecipe = try? coreDataManager.fetchingRecipes() else { return }
        XCTAssertEqual(fetchedRecipe.first?.name, "Chicken")
        XCTAssertEqual(fetchedRecipe.first?.time, 30)
        XCTAssertEqual(fetchedRecipe.first?.url, "URL RECIPE")
        XCTAssertEqual(fetchedRecipe.first?.urlImage, "URL IMAGE")
        XCTAssertEqual(fetchedRecipe.first?.ingredients, ["Chicken and curry"])
        XCTAssertEqual(fetchedRecipe.first?.ingredientLines, ["300G OF CHICKEN, 300G OF CURRY"])
       
    }
    
    func test_deletingARecipe() {
        let newRecipe = coreDataManager.addingNewRecipe(recipe: nil, name: "Chicken", calories: 800, time: 30, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["Chicken and curry"], ingredientLines: ["300G OF CHICKEN, 300G OF CURRY"])
        
        try? coreDataManager.context.save()
       
        coreDataManager.deletingRecipe(deleting: newRecipe)
        
        guard let fetchedRecipe = try? coreDataManager.fetchingRecipes() else { return }
        XCTAssertEqual(fetchedRecipe, [])
    }
    
    func test_checkingIfARecipeNameAlreadyExists() {
        let _ = coreDataManager.addingNewRecipe(recipe: nil, name: "Chicken", calories: 800, time: 30, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["Chicken and curry"], ingredientLines: ["300G OF CHICKEN, 300G OF CURRY"])
        
        try? coreDataManager.context.save()
    
        let recipeExists =  coreDataManager.checkingIfRecipeIsAlreadyInFavorites(nameOfRecipe: "Chicken")
        XCTAssertTrue(recipeExists)
        
    }
    
    func test_nameOfRecipeDoesNotExists() {
        let _ = coreDataManager.addingNewRecipe(recipe: nil, name: "Chicken", calories: 800, time: 30, url: "URL RECIPE", urlImage: "URL IMAGE", ingredients: ["Chicken and curry"], ingredientLines: ["300G OF CHICKEN, 300G OF CURRY"])
    
        try? coreDataManager.context.save()
        
        let recipeDoesNotExists =  coreDataManager.checkingIfRecipeIsAlreadyInFavorites(nameOfRecipe: "Tomato")
        XCTAssertFalse(recipeDoesNotExists)
        
    }
    
    func test_whenTryingToCheckIfThereIsAlreadyARecipeNameButThereIsNoRecipeInStore() {
                
        let name = coreDataManager.checkingIfRecipeIsAlreadyInFavorites(nameOfRecipe: "oui")
        
        XCTAssertFalse(name)
    }
}
