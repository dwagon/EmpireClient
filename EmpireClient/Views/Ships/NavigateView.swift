//
//  NavigateView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 1/9/2026.
//

import SwiftUI

struct NavigateView: View {
    var game: Game
    var ship: Ship
    @Binding var destination: MapCoord
    @Binding var viewMode: ShipViewMode
    @State var origLocation: MapCoord

    init(
        game: Game,
        ship: Ship,
        destination: Binding<MapCoord>,
        viewMode: Binding<ShipViewMode>
    ) {
        self.game = game
        self.ship = ship
        self._destination = destination
        self._viewMode = viewMode
        self._origLocation = State(initialValue: destination.wrappedValue)
    }

    var body: some View {
        VStack {
            Label(
                "Navigate Ship \(ship.number) \(ship.name)",
                systemImage: "arrow.up.and.down.and.arrow.left.and.right"
            )
            .font(
                .title
            )
            HStack {
                Button("Cancel") {
                    viewMode = .overview
                    destination = origLocation
                }
                Button("Navigate to \(destination.toString())") {
                    navigateToLocation(destination, ship: ship)
                    viewMode = .overview
                }.disabled(destination == origLocation)
            }
        }.padding()
            .onAppear {
                origLocation = destination
            }
    }

    func navigateToLocation(_ destination: MapCoord, ship: Ship) {
        Task {
            await game.cmd_navigate(
                ship: ship,
                destination: destination
            )
            await game.cmd_sdump(ship)
            await game.cmd_map(cmdArg: String(ship.number))
        }
    }
}
