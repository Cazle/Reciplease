import Foundation

// MARK: - Welcome
struct APIRequestModel: Codable {
    let from, to, count: Int
    let links: Links
    let hits: [Hit]

    enum CodingKeys: String, CodingKey {
        case from, to, count
        case links = "_links"
        case hits
    }
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
    let links: Links

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}

// MARK: - Links
struct Links: Codable {
    let linksSelf, next: Next

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case next
    }
}

// MARK: - Next
struct Next: Codable {
    let href, title: String
}

// MARK: - Recipe
struct Recipe: Codable {
    let uri, label, image: String
    let images: Images
    let source, url, shareAs: String
    let yield: Int
    let dietLabels, healthLabels, cautions, ingredientLines: [String]
    let ingredients: [Ingredient]
    let calories, glycemicIndex, totalCO2Emissions: Int
    let co2EmissionsClass: String
    let totalWeight: Int
    let cuisineType, mealType, dishType, instructions: [String]
    let tags: [String]
    let externalID: String
    let totalNutrients, totalDaily: TotalDaily
    let digest: [Digest]

    enum CodingKeys: String, CodingKey {
        case uri, label, image, images, source, url, shareAs, yield, dietLabels, healthLabels, cautions, ingredientLines, ingredients, calories, glycemicIndex, totalCO2Emissions, co2EmissionsClass, totalWeight, cuisineType, mealType, dishType, instructions, tags
        case externalID = "externalId"
        case totalNutrients, totalDaily, digest
    }
}

// MARK: - Digest
struct Digest: Codable {
    let label, tag, schemaOrgTag: String
    let total: Int
    let hasRDI: Bool
    let daily: Int
    let unit: String
    let sub: TotalDaily
}

// MARK: - TotalDaily
struct TotalDaily: Codable {
}

// MARK: - Images
struct Images: Codable {
    let thumbnail, small, regular, large: Large

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - Large
struct Large: Codable {
    let url: String
    let width, height: Int
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    let quantity: Int
    let measure, food: String
    let weight: Int
    let foodID: String

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight
        case foodID = "foodId"
    }
}

