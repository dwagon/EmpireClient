//
//  FleetAddView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/9/2026.
//

import SwiftUI

struct FleetAddView: View {
    var game: Game
    var ship: Ship
    @Binding var viewMode: ShipViewMode
    @State var fleet: String = ""
    @FocusState private var focused: Bool

    init(
        game: Game,
        ship: Ship,
        viewMode: Binding<ShipViewMode>
    ) {
        self.game = game
        self.ship = ship
        self._viewMode = viewMode

        let existingFleet = ship.fleet
        self._fleet = State(initialValue: existingFleet)
    }

    var body: some View {
        VStack {
            Label(
                "Add Ship \(ship.number) \(ship.name) to Fleet",
                systemImage: "oar.2.crossed"
            )
            .font(
                .title
            )
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

    func addToFleet() async {
        await game.cmd_fleetadd(fleet: fleet, ship: ship)
        await game.cmd_sdump(ship)
    }
}
