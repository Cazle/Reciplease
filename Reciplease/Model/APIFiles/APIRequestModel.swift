import Foundation

// MARK: - Welcome3
struct APIRequestModel: Codable {
    let hits: [Hit]
}
struct Hit: Codable {
    let recipe: Recipe
}
struct Recipe: Codable {
    let label: String
    let images: Images
    let url: String
    let ingredientLines: [String]
    let ingredients: [Ingredients]
    let calories: Double
    let totalTime: Int?
}
struct Images: Codable {
    let regular: Regular
    
    enum CodingKeys: String, CodingKey {
        case regular = "REGULAR"
    }
}
struct Ingredients: Codable {
    let text: String
    let food: String
}
struct Regular: Codable {
    let url: String
    let width: Int
    let height: Int
}



