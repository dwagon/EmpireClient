//
//  LandUpgradeView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 2/10/2026.
//

import SwiftUI

struct LandUpgradeView: View {
    var game: Game
    var unit: LandUnit
    @Binding var viewMode: LandViewMode

    var body: some View {
        VStack {
            Label(
                "Upgrade Land Unit",
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
                        upgradeLand(unit: unit)
                    }
                    viewMode = .overview
                }
            }
        }.padding()
    }

    func upgradeLand(unit: LandUnit) {
        Task {
            await game.cmd_upgrade(unit: unit)
            await game.cmd_ldump(unit)
            await game.cmd_dump(unit.coords)
        }
    }

}
