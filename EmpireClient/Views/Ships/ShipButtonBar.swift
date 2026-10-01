//
//  ShipButtonBar.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/9/2026.
//

import SwiftUI

struct ShipButtonBar: View {
    var game: Game
    @Binding var selectedShip: Ship.ID?
    @Binding var viewMode: ShipViewMode

    var body: some View {
            VStack {
                refreshButton

                if selectedShip != nil {
                    if viewMode != .overview {
                        backButton
                    }
                    loadButton
                    unloadButton
                    navigateButton
//                    assaultButton
                    nameButton
                    fleetAddButton
                    tendButton
                    if let selectedShip, let ship = game.ships[selectedShip], let sector = game.gameMap[ship.coords] {
                        if sector.desig.desig == .harbor {
                            upgradeButton
                        }
                    }
                }
            }
        }

    var backButton: some View {
        return Button("Back") {
            viewMode = .overview
        }
    }

    var refreshButton: some View {
        return
            Button("Refresh") {
                Task {
                    await game.cmd_map()
                    await game.cmd_sdump()
                }
            }
    }

    var loadButton: some View {
        Button("Load") {
            viewMode = .load
        }
    }

    var unloadButton: some View {
        Button("Unload") {
            viewMode = .unload
        }
    }

    var assaultButton: some View {
        Button("Assault") {
//            showAssaultPopup = true
        }
    }

    var navigateButton: some View {
        Button("Navigate") {
            viewMode = .navigate
        }
    }

    var nameButton: some View {
        Button("Name") {
            viewMode = .name
        }
    }

    var fleetAddButton: some View {
        Button("Add to Fleet") {
            viewMode = .fleetAdd
        }
    }

    var tendButton: some View {
        Button("Tend") {
            viewMode = .tend
        }
    }

    var upgradeButton: some View {
        Button("Upgrade") {
            viewMode = .upgrade
        }
    }
}
