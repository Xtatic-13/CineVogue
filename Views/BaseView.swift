import SwiftUI

// SearchBar Component
struct SearchBar: View {
    @Binding var text: String
    var onSearch: (() -> Void)?
    
    @FocusState private var isFocused: Bool  // Focus state to manage keyboard visibility
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text, onCommit: {
                onSearch?()
                isFocused = false // Dismiss keyboard on commit
            })
            .focused($isFocused) // Bind focus state to TextField
            .padding(7)
            .padding(.horizontal, 10)
            .background(Color(.systemGray6))
            .cornerRadius(8)

            
            // Cancel button (When keyboard is active)
            if isFocused {
                Button(action: {
                    text = ""
                    isFocused = false // Dismiss keyboard when tapped outside
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                }
                .padding(.trailing, 10)
            }
        }
        .padding(.horizontal)
        .onTapGesture {
            isFocused = true  // Ensure the text field gets focused when tapping
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            // Manually force focus if needed
                            isFocused = true
                        }

        }
    }
}

// MovieCard Component
struct MovieCard: View {
    var movie: Movie

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: movie.poster)) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 180)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
                    .frame(width: 120, height: 180)
            }
            Text(movie.title)
                .font(.caption)
                .lineLimit(1)
                .padding([.top, .horizontal], 4)
        }
        .frame(width: 120)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}

// BaseView Component
struct BaseView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            ThemeManager.shared.currentTheme.backgroundColor.ignoresSafeArea()
            content
        }
    }
}

