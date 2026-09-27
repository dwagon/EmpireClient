//
//  Color+String.swift
//  EmpireClient
//
//  Created by Dougal Scott on 27/9/2026.
//

import SwiftUI

extension Color {
    /// Initialize a SwiftUI Color from a hex string like "#RRGGBB" or "#RRGGBBAA"
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            print("Fail1")
            return nil
        }

        switch hexSanitized.count {
        case 6: // RRGGBB
            let r = Double((rgb & 0xFF0000) >> 16) / 255
            let g = Double((rgb & 0x00FF00) >> 8) / 255
            let b = Double(rgb & 0x0000FF) / 255
            self.init(red: r, green: g, blue: b)
        case 8: // RRGGBBAA
            let r = Double((rgb & 0xFF000000) >> 24) / 255
            let g = Double((rgb & 0x00FF0000) >> 16) / 255
            let b = Double((rgb & 0x0000FF00) >> 8) / 255
            let a = Double(rgb & 0x000000FF) / 255
            self.init(red: r, green: g, blue: b, opacity: a)
        default:
            print("Fail2")
            return nil
        }
    }
}
