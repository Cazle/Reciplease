import Foundation

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
    let image: String
    let images: Images
    let url: String
    let ingredientLines: [String]
    let ingredients: [Ingredients]
}
struct Images: Codable {
    let thumbnail: Thumbnail
    let small: Small
    let regular: Regular
    
    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
    }
}
struct Ingredients: Codable {
    let text: String
    let food: String
}
struct Thumbnail: Codable {
    let url: String
    let width: Int
    let height: Int
}
struct Small: Codable {
    let url: String
    let width: Int
    let height: Int
}
struct Regular: Codable {
    let url: String
    let width: Int
    let height: Int
}



