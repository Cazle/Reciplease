import XCTest
@testable import Reciplease

final class DecodingRecipeModelTests: XCTestCase {
    
    func test_tryingToRequestRecipeWhenTheDataIsNil() {
        let correctURL = URL(string: "https://apple.com")!
        let dataNil: Data? = nil
        let correctResponse = HTTPURLResponse(url: correctURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        let sut = DecodingRecipeModel(apiHandler: APICallStub(result: (dataNil, correctResponse)))
        
        let exp = expectation(description: "Waiting...")
        
        sut.requestRecipe(url: correctURL) { response in
            switch response {
            case .success:
                XCTFail("The decoding should fail.")
            case .failure(let error):
                exp.fulfill()
                XCTAssertEqual(error as! APIError, .invalidData)
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
    func test_tryingToRequestRecipeAndTheDataAreNotCorrectSoTheDecodingFails() {
        let correctURL = URL(string: "https://apple.com")!
        let wrongData = Data("dataNotDecodable".utf8)
        let correctResponse = HTTPURLResponse(url: correctURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        let sut = DecodingRecipeModel(apiHandler: APICallStub(result: (wrongData, correctResponse)))
        
        let exp = expectation(description: "Waiting...")
        
        sut.requestRecipe(url: correctURL) { response in
            switch response {
            case .success:
                XCTFail("The decoding should fail.")
            case .failure(let error):
                exp.fulfill()
                XCTAssertEqual(error as! APIError, .invalidDecoding)
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
    func test_statusCodeIsDifferentThan200() {
        let correctURL = URL(string: "https://apple.com")!
        let uncorrectResponse = HTTPURLResponse(url: correctURL, statusCode: 500, httpVersion: nil, headerFields: nil)!
        
        let sut = DecodingRecipeModel(apiHandler: APICallStub(result: (Data(), uncorrectResponse)))
        
        let exp = expectation(description: "Waiting...")
        
        sut.requestRecipe(url: correctURL) { response in
            switch response {
            case .success:
                XCTFail("The decoding should fail.")
            case .failure(let error):
                exp.fulfill()
                XCTAssertEqual(error as! APIError, .invalidStatusCode)
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
    func test_whenTheHTTPURLResponseIsNilSoTheResponseFails() {
        let correctURL = URL(string: "https://apple.com")!
        let uncorrectResponse: HTTPURLResponse? = nil
        
        let sut = DecodingRecipeModel(apiHandler: APICallStub(result: (Data(), uncorrectResponse)))
        
        let exp = expectation(description: "Waiting...")
        
        sut.requestRecipe(url: correctURL) { response in
            switch response {
            case .success:
                XCTFail("The decoding should fail.")
            case .failure(let error):
                exp.fulfill()
                XCTAssertEqual(error as! APIError, .invalidResponse)
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
    func test_whenAPIRequestIsASuccessAndDecoded() {
        let correctURL = URL(string: "https://apple.com")!
        let correctResponse = HTTPURLResponse(url: correctURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let correctData = Data(fakeJSON.utf8)
        
        let sut = DecodingRecipeModel(apiHandler: APICallStub(result: (correctData, correctResponse)))
        
        let exp = expectation(description: "Waiting...")
        
        sut.requestRecipe(url: correctURL) { response in
            switch response {
            case .success(let data):
                let hits = data.hits
                let recipe = hits[0].recipe
                exp.fulfill()
                XCTAssertEqual(recipe.label, "Chicken")
                XCTAssertEqual(recipe.calories, 10)
            case .failure:
                XCTFail("Fail")
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
}
