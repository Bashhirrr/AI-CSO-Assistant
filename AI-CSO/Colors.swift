//
//  Colors.swift
//  AI-CSO
//
//  Created by Aliyu Khalifa on 28/11/2025.
//

import SwiftUI

// MARK: - Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)

        if hex.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - App Colors
extension Color {
    static let redPrimary = Color(hex: "A80000")    // Dark red
    static let redLight = Color(hex: "F6E6E6")      // Light red / pinkish
    static let redAccent = Color(hex: "970000")     // Accent red
    static let redHighlight = Color(hex: "A91717")  // Highlight red
}

