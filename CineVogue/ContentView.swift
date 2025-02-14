import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MovieViewModel()
    
    var body: some View {
        NavigationView {
            BaseView {
                VStack {
                    SearchBar(text: $viewModel.searchText, onSearch: {
                        viewModel.fetchMovies(query: viewModel.searchText, page: 1)
                    })
                    .padding()
                    
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                            // Display each movie as a MovieCard
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel)) {
                                    MovieCard(movie: movie)
                                }
                            }
                        }
                        
                        if viewModel.movies.isEmpty {
                            Text("No movies found")
                                .font(.headline)
                                .padding()
                        }
                        
                        // Show progress view if more movies need to be loaded
                        if viewModel.movies.count < viewModel.totalResults {
                            ProgressView()
                                .onAppear {
                                    viewModel.loadNextPage()
                                }
                        }
                        
                        NavigationLink(destination: FavoritesView(viewModel: viewModel)) {
                            Text("Go to Favorites")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    .navigationTitle("CineVogue")
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
