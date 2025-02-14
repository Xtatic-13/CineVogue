import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieViewModel  // Observing the MovieViewModel

    var body: some View {
        VStack {
            // Show movie poster
            if let imageUrl = URL(string: movie.poster) {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 180)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
                .frame(width:120, height: 180)
            }

            // Movie title
            Text(movie.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            // Movie year
            Text(movie.year)
                .font(.subheadline)
                .foregroundColor(.gray)

            // Movie plot if available
            if let plot = movie.plot {
                Text(plot)
                    .padding(.top)
            }
            
            // Favorite Button
            Button(action: {
                viewModel.toggleFavorite(movie: movie)
            }) {
                    Text(viewModel.favorites.contains(where: { $0.imdbID == movie.imdbID }) ? "Remove from Favorites" : "Add to Favorites")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
            }
            .padding()


            Spacer()
        }
        .padding()
        .navigationTitle(movie.title)
    }
}



