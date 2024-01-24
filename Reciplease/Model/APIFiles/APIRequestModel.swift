import Foundation

// MARK: - Welcome3
struct APIRequestModel: Decodable {
    let hits: [Hit]
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case hits
    }
}
struct Links: Decodable {
    let next: Next
}
struct Next: Decodable {
    let href: String
    let title: String
}

struct Hit: Decodable {
    let recipe: Recipe
}
struct Recipe: Decodable {
    let label: String
    let images: Images
    let url: String
    let ingredientLines: [String]
    let ingredients: [Ingredients]
    let calories: Double
    let totalTime: Int?
}
struct Images: Decodable {
    let regular: Regular
    
    enum CodingKeys: String, CodingKey {
        case regular = "REGULAR"
    }
}
struct Ingredients: Decodable {
    let text: String
    let food: String
}
struct Regular: Decodable {
    let url: String
}



