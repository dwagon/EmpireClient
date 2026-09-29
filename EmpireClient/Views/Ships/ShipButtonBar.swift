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
                    loadButton
//                    unloadButton
                    navigateButton
//                    assaultButton
//                    nameButton
//                    fleetAddButton
                }
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
//            showUnloadPopup = true
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
//            showNamePopup = true
        }
    }

    var fleetAddButton: some View {
        Button("Add to Fleet") {
//            showFleetAddPopup = true
        }
    }
}
