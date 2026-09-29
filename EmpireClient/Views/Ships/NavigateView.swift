//
//  NavigateView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 1/9/2026.
//

import SwiftUI

struct NavigateView: View {
    var game: Game
    var selectedShip: Ship.ID?
    @Binding var destination: MapCoord
    @Binding var viewMode: ShipViewMode
    @State var origLocation: MapCoord = MapCoord(x: 0, y: 0)

    var body: some View {
        VStack {
            Label(
                "Navigate Ship \(selectedShip, default: "")",
                systemImage: "arrow.up.and.down.and.arrow.left.and.right"
            )
            .font(
                .title
            )
            if selectedShip != nil {
                ShipDetailView(game: game, selectedShip: selectedShip)
                Text(
                    "Navigate to Destination: \(destination.toString()) from \(origLocation.toString())"
                )
            }
            HStack {
                Button("Cancel") {
                    viewMode = .overview
                    destination = origLocation
                }
                Button("Navigate") {
                    navigateToLocation(destination, ship: selectedShip)
                    viewMode = .overview
                }.disabled(selectedShip == nil)
            }
        }.padding()
            .onAppear {
                origLocation = destination
            }
    }

    func navigateToLocation(_ destination: MapCoord?, ship: Ship.ID?) {
        Task {
            if let destination, let selectedShip,
                let ship = game.ships[selectedShip]
            {
                await game.cmd_navigate(
                    ship: ship,
                    destination: destination
                )
                await game.cmd_sdump(ship)
                await game.cmd_map(cmdArg: String(ship.number))
            }
        }
    }
}
