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
    @Binding var sectorSelect: Bool
    @State var origLocation: MapCoord

    init(
        game: Game,
        ship: Ship,
        destination: Binding<MapCoord>,
        viewMode: Binding<ShipViewMode>,
        sectorSelect: Binding<Bool>
    ) {
        self.game = game
        self.ship = ship
        self._destination = destination
        self._viewMode = viewMode
        self._origLocation = State(initialValue: destination.wrappedValue)
        self._sectorSelect = sectorSelect
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
                CancelButton() {
                    viewMode = .overview
                    sectorSelect = true
                    destination = origLocation
                }
                OkButton("Navigate to \(destination.toString())", disabled: destination == origLocation) {
                    navigateToLocation(destination, ship: ship)
                    viewMode = .overview
                    sectorSelect = true
                }
            }
        }.padding()
            .onAppear {
                origLocation = destination
                sectorSelect = false
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
