import SwiftUI

class ThemeManager {
    static let shared = ThemeManager()
    
    enum Theme {
        case light, dark

        var backgroundColor: Color {
            switch self {
            case .light: return Color.white
            case .dark: return Color.black
            }
        }
    }

    var currentTheme: Theme {
        return UserDefaults.standard.bool(forKey: "isDarkMode") ? .dark : .light
    }
}

