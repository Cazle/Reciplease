import Foundation
import XCTest
@testable import Reciplease

final class IngredientStoreTests: XCTestCase {
    
    
    func test_testingTheAddMethod() {
        
        let sut = IngredientStore()
        
        sut.add(ingredient: "Chicken")
        sut.add(ingredient: "Tomato")
        
        XCTAssertEqual(sut.ingredients, ["Chicken", "Tomato"])
    }
    
    func test_testingTheDeletingMethod() {
        
        let sut = IngredientStore()
        
        sut.ingredients = ["Chicken", "Tomato"]
        sut.deleteAll()
        
        XCTAssertEqual(sut.ingredients, [])
    }
    
}
