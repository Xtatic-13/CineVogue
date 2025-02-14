import Foundation
import Combine

class APIService {
    static let shared = APIService()
    private let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""

    // Fetch Movies by Title
    func fetchMovies(query: String, page: Int, type: String = "movie", plotType: String = "short") -> AnyPublisher<(movies: [Movie], totalResults: Int), Never> {
        let formattedQuery = query.replacingOccurrences(of: " ", with: "+")
        var urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(formattedQuery)&page=\(page)"
        
        // Append optional parameters if provided
        if !type.isEmpty {
            urlString += "&type=\(type)"
        } 
        if !plotType.isEmpty {
            urlString += "&plot=\(plotType)"
        }
        
        guard let url = URL(string: urlString) else {
            return Just(([], 0)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .map { ($0.Search ?? [], Int($0.totalResults ?? "0") ?? 0) }
            .replaceError(with: ([], 0))
            .eraseToAnyPublisher()
    }

    // Fetch Movie by IMDb ID
    func fetchMovieByID(imdbID: String, type: String = "movie", plotType: String = "short") -> AnyPublisher<Movie, Never> {
        var urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(imdbID)"
        
        // Append optional parameters if provided
        if !type.isEmpty {
            urlString += "&type=\(type)"
        }
        if !plotType.isEmpty {
            urlString += "&plot=\(plotType)"
        }
        
        guard let url = URL(string: urlString) else {
            return Just(Movie(imdbID: "", title: "Invalid URL", year: "", poster: "", genre: "", imdbRating: nil, plot: "Error: URL encoding failed", actors: nil)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Movie.self, decoder: JSONDecoder())
            .replaceError(with: Movie(imdbID: "", title: "Decoding Error", year: "", poster: "", genre: "", imdbRating: nil, plot: "Error: Unable to decode response", actors: nil))
            .eraseToAnyPublisher()
    }
}



