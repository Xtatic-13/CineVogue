import Foundation

struct LocalizationManager {
    static func localize(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

