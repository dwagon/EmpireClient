//
//  NameShipView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 17/9/2026.
//

import SwiftUI

struct NameShipView: View {
    var game: Game
    var ship: Ship
    @Binding var viewMode: ShipViewMode
    @State var name: String = ""
    @FocusState private var focused: Bool

    init(
        game: Game,
        ship: Ship,
        viewMode: Binding<ShipViewMode>
    ) {
        self.game = game
        self.ship = ship
        self._viewMode = viewMode

        let existingName: String = ship.name
        self._name = State(initialValue: existingName)
    }

    var body: some View {
        VStack {
            Label(
                "Name Ship \(ship.number) \(ship.name)",
                systemImage: "person.text.rectangle.fill"
            )
            .font(
                .title
            )
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

    func nameShip() async {
        await game.cmd_name(ship: ship, name: name)
        await game.cmd_sdump(ship)
    }
}
