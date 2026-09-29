//
//  FleetAddView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/9/2026.
//

import SwiftUI

struct FleetAddView: View {
    var game: Game
    var selectedShip: Ship.ID?
    @Binding var viewMode: ShipViewMode
    @State var fleet: String = ""
    @FocusState private var focused: Bool

    init(
        game: Game,
        selectedShip: Ship.ID?,
        viewMode: Binding<ShipViewMode>
    ) {
        self.game = game
        self.selectedShip = selectedShip
        self._viewMode = viewMode

        let existingFleet: String
        if let selectedShip,
            let ship = game.ships[selectedShip]
        {
            existingFleet = ship.fleet
        } else {
            existingFleet = ""
        }

        self._fleet = State(initialValue: existingFleet)
    }

    var body: some View {
        VStack {
            Label(
                ship.map { "Add Ship \($0.number) to Fleet" } ?? "Error",
                systemImage: "oar.2.crossed"
            )
            .font(
                .title
            )
            ShipDetailView(game: game, selectedShip: selectedShip)

            HStack {
                TextField(
                    "Fleet",
                    text: $fleet
                )
                .focused($focused)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .frame(idealWidth: 100, maxWidth: 150)
                .onChange(of: fleet) { _, newValue in
                    if newValue.count > 1 {
                        fleet = String(newValue.prefix(1))
                    }
                }
            }
            HStack {
                CancelButton {
                    viewMode = .overview
                }
                OkButton("Add", disabled: fleet.isEmpty) {
                    Task {
                        await addToFleet()
                        viewMode = .overview
                    }
                }
            }
        }.padding()
            .onAppear {
                focused = true
            }
    }

    var ship: Ship? {
        guard let selectedShip, let ship = game.ships[selectedShip] else {
            return nil
        }
        return ship
    }

    func addToFleet() async {
        guard let ship else { return }
        await game.cmd_fleetadd(fleet: fleet, ship: ship)
        await game.cmd_sdump(ship)
    }
}
