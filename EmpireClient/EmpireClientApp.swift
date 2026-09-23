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
            ContentView(game: game, centerCoord: MapCoord(x: 0, y: 0))
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
                Button("Power", systemImage: "powermeter") {
                    openWindow(id: "power_report")
                }
                Button("Land Unit Types", systemImage: "car.rear.road.lane.distance.5") {
                    openWindow(id: "land_types_report")
                }.disabled(game.landTypes.isEmpty)
                Button("Ship Types", systemImage: "sailboat") {
                    openWindow(id: "ship_types_report")
                }.disabled(game.shipTypes.isEmpty)
                Button("Plane Types", systemImage: "airplane.up.right") {
                    openWindow(id: "plane_types_report")
                }.disabled(game.planeTypes.isEmpty)
                Button("Nuke Types", systemImage: "exclamationmark.icloud.fill") {
                    openWindow(id: "nuke_types_report")
                }.disabled(game.planeTypes.isEmpty)
            }
        }

        Window("Nation Report", id: "nation_report") {
            NationReport(game: game)
        }

        Window("Budget Report", id: "budget_report") {
            BudgetReport(game: game)
        }

        Window("Ship Types Report", id: "ship_types_report") {
            ShipTypeReport(shipTypes: Array(game.shipTypes.values).sorted(by: { $0.tech < $1.tech}), currTech: game.techLevel)
        }

        Window("Land Unit Types Report", id: "land_types_report") {
            LandTypeReport(landTypes: Array(game.landTypes.values).sorted(by: { $0.tech < $1.tech}), currTech: game.techLevel)
        }

        Window("Plane Types Report", id: "plane_types_report") {
            PlaneTypeReport(planeTypes: Array(game.planeTypes.values).sorted(by: { $0.tech < $1.tech}), currTech: game.techLevel)
        }

        Window("Nuke Types Report", id: "nuke_types_report") {
            NukeTypeReport(nukeTypes: Array(game.nukeTypes.values).sorted(by: { $0.tech < $1.tech}), currTech: game.techLevel)
        }

        Window("Power Report", id: "power_report") {
            PowerReport(game: game)
        }
    }
}
