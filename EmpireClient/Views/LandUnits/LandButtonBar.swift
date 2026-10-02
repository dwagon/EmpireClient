//
//  LandButtonBar.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/9/2026.
//

import SwiftUI

struct LandButtonBar: View {
    var game: Game
    @Binding var selectedUnit: LandUnit.ID?
    @Binding var viewMode: LandViewMode

    var body: some View {
        VStack {
            refreshButton

            if selectedUnit != nil {
                if viewMode != .overview {
                    backButton
                }
                loadButton
                fortifyButton
                marchButton
                if let selectedUnit, let unit = game.landUnits[selectedUnit], let sector = game.gameMap[unit.coords] {
                    if sector.desig.desig == .headquarters {
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
                    await game.cmd_ldump()
                }
            }
    }

    var loadButton: some View {
        return
            Button("Load") {
                viewMode = .load
            }
    }

    var fortifyButton: some View {
        return
            Button("Fortify") {
                viewMode = .fortify
            }
    }

    var marchButton: some View {
        return
            Button("March") {
                viewMode = .march
            }
    }

    var upgradeButton: some View {
        return
            Button("Upgrade") {
                viewMode = .upgrade
            }
    }
}
