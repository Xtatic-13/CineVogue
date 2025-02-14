import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: MovieViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.favorites) { movie in
                Text(movie.title)
            }
            .onDelete { indexSet in
                viewModel.favorites.remove(atOffsets: indexSet)
            }
        }
        .navigationTitle("Favorites")
    }
}

