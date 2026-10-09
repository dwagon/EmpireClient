//
//  ShipDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 27/8/2026.
//

import SwiftUI

struct ShipTableView: View {
    var game: Game
    @Binding var centerCoord: MapCoord
    @Binding var selectedShip: Ship.ID?
    @State private var sortOrder = [KeyPathComparator(\Ship.number)]
    @State private var ships: [Ship]

    init(
        game: Game,
        centerCoord: Binding<MapCoord>,
        selectedShip: Binding<Ship.ID?>
    ) {
        self.game = game
        self._centerCoord = centerCoord
        self._selectedShip = selectedShip
        self.ships = Array(game.ships.values)
    }

    var body: some View {
        Table(ships, selection: $selectedShip, sortOrder: $sortOrder) {
            TableColumn("Ship #", value: \.number) { val in Text("\(val.number)") }
                .standardWidth()

            TableColumn("Name", value: \.name) { val in
                Text("\(val.name)")
            }

            TableColumn("Type", value: \.abbrev) { val in
                if let type = game.shipTypes[val.abbrev] {
                    Text(
                        "\(type.name) (\(val.abbrev))"
                    )
                } else {
                    Text("\(val.abbrev)")
                }
            }

            TableColumn("Coord", value: \.coords) { val in
                Text("\(val.coords.toString(), default: "unknown")")
            }.standardWidth()

            TableColumn("Fleet", value: \.fleet) { val in
                Text("\(val.fleet)")
            }.standardWidth()

            TableColumn("Mob", value: \.mob) { val in Text("\(val.mob)") }
                .standardWidth()

            TableColumn("Eff", value: \.eff) { val in Text("\(val.eff)%") }
                .standardWidth()

            TableColumn("Notes") { val in
                Text("\(val.cargoString())")
            }
        }
        .onChange(of: selectedShip) {
            guard let selectedShip, let ship = game.ships[selectedShip] else {
                return
            }
            centerCoord = ship.coords
        }
        .onChange(of: sortOrder) { _, sortOrder in
            ships.sort(using: sortOrder)
        }
    }
}
