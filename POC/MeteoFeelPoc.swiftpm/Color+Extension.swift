import SwiftUI

extension Color {
    
    // MARK: - Background

    static let warmDarkRich = Color(red: 0.21, green: 0.18, blue: 0.16)
    static let warmDarkSoft = Color(red: 0.13, green: 0.11, blue: 0.10)
    static let warmBeigeLight = Color(red: 1.00, green: 0.98, blue: 0.94)
    static let warmBeigeDark = Color(red: 0.91, green: 0.87, blue: 0.80)

    static let darkModeBackgroundGradient: [Color] = [.warmDarkRich, .warmDarkSoft]
    static let lightModeBackgroundGradient: [Color] = [.warmBeigeLight, .warmBeigeDark]
    
    // MARK: - Weather icons

    static let cloudColor = Color(red: 0.8, green: 0.8, blue: 0.85)
    static let snowColor = Color(red: 0.7, green: 0.85, blue: 1.0)
    static let lightRainColor = Color(red: 0.3, green: 0.5, blue: 0.9)
    static let heavyRainColor = Color(red: 0.2, green: 0.4, blue: 0.8)
} 