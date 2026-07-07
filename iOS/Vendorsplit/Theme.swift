import SwiftUI

/// warm potluck orange on deep forest green
enum Theme {
    static let accent = Color(red: 0.8784, green: 0.4784, blue: 0.2431)
    static let accentSecondary = Color(red: 0.1804, green: 0.3255, blue: 0.2235)
    static let background = Color(red: 0.1059, green: 0.1216, blue: 0.1020)
    static let cardBackground = background.opacity(0.6)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
}
