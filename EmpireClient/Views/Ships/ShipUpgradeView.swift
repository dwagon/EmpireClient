//
//  ShipUpgradeView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 2/10/2026.
//

import SwiftUI

struct ShipUpgradeView: View {
    var game: Game
    var ship: Ship
    @Binding var viewMode: ShipViewMode

    var body: some View {
        VStack {
            Label(
                "Upgrade Ship",
                systemImage: "suv.side.arrowtriangle.up"
            )
            .font(
                .title
            )
            HStack {
                CancelButton {
                    viewMode = .overview
                }
                OkButton("Upgrade") {
                    Task {
                        upgradeShip(ship: ship)
                    }
                    viewMode = .overview
                }
            }
        }.padding()
    }

    func upgradeShip(ship: Ship) {
        Task {
            await game.cmd_upgrade(ship: ship)
            await game.cmd_sdump(ship)
            await game.cmd_dump(ship.coords)
        }
    }
}
