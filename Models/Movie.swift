import Foundation

struct Movie: Identifiable, Codable {
    var id = UUID()  // Keeping id for Identifiable protocol, but it won't come from API
    let imdbID: String
    let title: String
    let year: String
    let poster: String
    let genre: String?
    let imdbRating: String?
    let plot: String?
    let actors: String?
    var type: String?
    var plotType: String?

    // Correctly placed CodingKeys
    enum CodingKeys: String, CodingKey {
        case imdbID = "imdbID"
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case genre = "Genre"
        case imdbRating = "imdbRating"
        case plot = "Plot"
        case actors = "Actors"
        case type = "Type"
    }
}


