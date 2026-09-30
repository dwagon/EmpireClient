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

    var body: some View {
        HStack {
            VStack {
                Table(game.landTable, selection: $selectedUnit) {
                    TableColumn("Unit #") { val in
                        Text("\(val.number)")
                    }
                    .standardWidth()
                    TableColumn("Type") { val in
                        Text(
                            "\(game.landTypes[val.abbrev]!.name) (\(val.abbrev))"
                        )
                    }
                    TableColumn("Coord") { val in
                        Text("\(val.coords.toString(), default: "unknown")")
                    }.standardWidth()

                    TableColumn("Mil") { val in
                        Text("\(val.cargo[.mil], default: "?")")
                    }.standardWidth()

                    TableColumn("Army") { val in Text("\(val.army)") }
                        .standardWidth()

                    TableColumn("Mob") { val in Text("\(val.mob)") }
                        .standardWidth()
                    TableColumn("Eff") { val in Text("\(val.eff)%") }
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
            }
        }
    }
}
