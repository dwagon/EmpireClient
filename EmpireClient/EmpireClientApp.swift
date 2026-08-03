//
//  EmpireClientApp.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import SwiftUI
import SwiftData

@main
struct EmpireClientApp: App {
    var game = Game()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(game: game, center_coord: MapCoord(x: 0, y: 0))
        }
        Settings {
       //     SettingsView()
        }
        .modelContainer(sharedModelContainer)
    }
}
