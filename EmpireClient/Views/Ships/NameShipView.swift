//
//  NameShipView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 17/9/2026.
//

import SwiftUI

struct NameShipView: View {
    var game: Game
    var selectedShip: Ship.ID?
    @Binding var viewMode: ShipViewMode
    @State var name: String = ""
    @FocusState private var focused: Bool

    init(
        game: Game,
        selectedShip: Ship.ID?,
        viewMode: Binding<ShipViewMode>
    ) {
        self.game = game
        self.selectedShip = selectedShip
        self._viewMode = viewMode

        let existingName: String
        if let selectedShip,
           let ship = game.ships[selectedShip] {
            existingName = ship.name
        } else {
            existingName = ""
        }

        self._name = State(initialValue: existingName)
    }

    var body: some View {
        VStack {
            Label(
                ship.map {"Name Ship \($0.number)"} ?? "Error",
                systemImage: "person.text.rectangle.fill"
            )
            .font(
                .title
            )
            ShipDetailView(game: game, selectedShip: selectedShip)
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        TextField(
                            "Name",
                            text: $name
                        ).focused($focused)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .frame(idealWidth: 100, maxWidth: 150)
                    }
                }
            }
            HStack {
                CancelButton {
                    viewMode = .overview
                }
                OkButton("Name", disabled: name.isEmpty) {
                    Task {
                        await nameShip()
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

    func nameShip() async {
        guard let ship else { return }
        await game.cmd_name(ship: ship, name: name)
        await game.cmd_sdump(ship)
    }
}
