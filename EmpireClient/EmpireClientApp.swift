//
//  EmpireClientApp.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import SwiftUI

@main
struct EmpireClientApp: App {
    var game = Game()
    var body: some Scene {
        WindowGroup {
            ContentView(game: game, center_coord: MapCoord(x: 0, y: 0))
        }
        Settings {
            SettingsView()
        }
    }
}
