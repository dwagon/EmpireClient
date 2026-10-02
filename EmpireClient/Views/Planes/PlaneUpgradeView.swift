//
//  PlaneUpgradeView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 2/10/2026.
//

import SwiftUI

struct PlaneUpgradeView: View {
    var game: Game
    var plane: Plane
    @Binding var viewMode: PlaneViewMode

    var body: some View {
        VStack {
            Label(
                "Upgrade Plane",
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
                        upgradePlane(plane: plane)
                    }
                    viewMode = .overview
                }
            }
        }.padding()
    }

    func upgradePlane(plane: Plane) {
        Task {
            await game.cmd_upgrade(plane: plane)
            await game.cmd_pdump(plane: plane)
            await game.cmd_dump(plane.coords)
        }
    }
}
