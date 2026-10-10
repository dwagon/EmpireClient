//
//  LandTableView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/9/2026.
//

import SwiftUI

struct LandTableView: View {
    var game: Game
    @Binding var centerCoord: MapCoord
    @Binding var selectedUnit: LandUnit.ID?
    @State private var sortOrder = [KeyPathComparator(\LandUnit.number)]
    @State private var landTable: [LandUnit]

    init(
        game: Game,
        centerCoord: Binding<MapCoord>,
        selectedUnit: Binding<LandUnit.ID?>
    ) {
        self.game = game
        self._centerCoord = centerCoord
        self._selectedUnit = selectedUnit
        self.landTable = Array(game.landUnits.values)
    }

    var body: some View {
        Table(
            landTable,
            selection: $selectedUnit,
            sortOrder: $sortOrder
        ) {
            TableColumn("Unit #", value: \.number) { val in
                Text("\(val.number)")
            }
            .standardWidth()
            TableColumn("Type", value: \.abbrev) { val in
                if let type = game.landTypes[val.abbrev] {
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

            TableColumn("Mil", value: \.numMil) { val in
                Text("\(val.numMil)")
            }.standardWidth()

            TableColumn("Army", value: \.army) { val in
                Text("\(val.army)")
            }
            .standardWidth()

            TableColumn("Mob", value: \.mob) { val in Text("\(val.mob)")
            }
            .standardWidth()
            TableColumn("Eff", value: \.eff) { val in
                Text("\(val.eff)%")
            }
            .standardWidth()
            TableColumn("Notes") { val in
                HStack {
                    if val.ship >= 0 {
                        Text("Aboard S\(val.ship)")
                    }
                    Text("\(val.cargoString())")
                }
            }
        }
        .onChange(of: selectedUnit) {
            centerCoord = game.landUnits[selectedUnit!]!.coords
        }
        .onChange(of: sortOrder) { _, sortOrder in
            landTable.sort(using: sortOrder)
        }
    }
}
