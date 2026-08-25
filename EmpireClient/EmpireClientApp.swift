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
    @Environment(\.openWindow) private var openWindow

    
    var body: some Scene {
        WindowGroup {
            ContentView(game: game, center_coord: MapCoord(x: 0, y: 0))
        }
        Settings {
            SettingsView()
        }
        .commands {
            CommandMenu("Reports") {
                Button("Nation", systemImage: "popcorn") {
                    openWindow(id: "nation_report")
                }
                Button("Budget", systemImage: "dollarsign.gauge.chart.lefthalf.righthalf") {
                    openWindow(id: "budget_report")
                }
                Button("Ship Types", systemImage: "sailboat") {
                    openWindow(id: "ship_types_report")
                }

            }
        }

        Window("Nation Report", id: "nation_report") {
            NationReport(game: game)
        }

        Window("Budget Report", id: "budget_report") {
            NationReport(game: game)
        }

        Window("Ship Types Report", id: "ship_types_report") {
            ShipTypeReport(shipTypes: game.shipTypes)
        }
    }
}
