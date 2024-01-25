import Foundation
import XCTest
@testable import Reciplease

final class URLEndpointTests: XCTestCase {
    
    func test_composingAnURLIsSuccessful() {
        let sut = URLEndpoint()
        
        let ingredientsToMakeURL = ["Tomato", "Onion", "Curry"]
        
        let url = sut.urlRecipe(with: ingredientsToMakeURL)
        
        XCTAssertEqual(url, URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=Tomato,Onion,Curry&app_id=cbfe9715&app_key=91e322d3c82707bcc618b8756198ac31"))
    }
    
}
