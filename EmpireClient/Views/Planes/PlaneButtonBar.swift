//
//  PlaneButtonBar.swift
//  EmpireClient
//
//  Created by Dougal Scott on 2/10/2026.
//

import SwiftUI

struct PlaneButtonBar: View {
    var game: Game
    @Binding var selectedPlane: Plane.ID?
    @Binding var viewMode: PlaneViewMode

    var body: some View {
            VStack {
                refreshButton

                if selectedPlane != nil {
                    if viewMode != .overview {
                        backButton
                    }
                    if let selectedPlane, let plane = game.planes[selectedPlane], let sector = game.gameMap[plane.coords] {
                        if sector.desig.desig == .airfield {
//                            upgradeButton
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
                    await game.cmd_pdump()
                }
            }
    }
}
