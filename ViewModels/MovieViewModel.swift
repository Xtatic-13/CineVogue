import SwiftUI
import Combine

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText = ""
    @Published var favorites: [Movie] = []
    @Published var currentPage = 1
    @Published var totalResults = 0
    @Published var searchByTitle = true // New state to toggle search type

    private var cancellables = Set<AnyCancellable>() // This is where Combine comes into the game
    
    init() {
        fetchMovies(query: "batman", page: 1)
    }
    
    // Fetch Movies by Title or IMDb ID
    func fetchMovies(query: String, page: Int) {
        let formattedQuery = query.replacingOccurrences(of: " ", with: "+")

        if searchByTitle {
            // If searching by Title
            APIService.shared.fetchMovies(query: formattedQuery, page: page)
                .subscribe(on: DispatchQueue.global(qos: .background)) 
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching movies: \(error.localizedDescription)")
                    case .finished:
                        print("Successfully fetched movies by title.")
                    }
                }, receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.movies = response.movies
                    self.totalResults = response.totalResults
                    print("Movies fetched: \(self.movies)") // Debugging line
                })
                .store(in: &cancellables)
        } 
        else {
            // If searching by IMDb ID
            APIService.shared.fetchMovieByID(imdbID: formattedQuery, type: "movie", plotType: "short")
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching movie by IMDb ID: \(error.localizedDescription)")
                    case .finished:
                        print("Successfully fetched movie by IMDb ID.")
                    }
                }, receiveValue: { [weak self] movie in
                    guard let self = self else { return }
                    self.movies = [movie] // Setting only the single movie result
                    self.totalResults = 1 // Only one result for IMDb ID search, ID being unique
                    print("Single movie fetched: \(self.movies)") // Debugging line
                })
                .store(in: &cancellables)
        }
    }

    
    // Load next page of movies (for title-based search)
    func loadNextPage() {
        guard movies.count < totalResults else { return }
        currentPage += 1
        fetchMovies(query: searchText, page: currentPage)
    }

    // Toggle Favorite
    func toggleFavorite(movie: Movie) {
        if favorites.contains(where: { $0.imdbID == movie.imdbID }) {
            favorites.removeAll { $0.imdbID == movie.imdbID }
        } else {
            favorites.append(movie)
        }
    }
}



