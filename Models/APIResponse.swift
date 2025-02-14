import Foundation

struct APIResponse: Decodable {
    let Search: [Movie]?
    let totalResults: String?
}
