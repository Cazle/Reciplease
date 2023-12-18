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
}
struct Images: Codable {
    let THUMBNAIL: Thumbnail
    let SMALL: Small
    let REGULAR: Regular
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



