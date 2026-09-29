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

    var body: some View {
        HStack {
            VStack {
                Table(game.shipTable, selection: $selectedShip) {
                    TableColumn("Ship #") { val in Text("\(val.number)") }
                        .standardWidth()

                    TableColumn("Name") { val in
                        Text("\(val.name)")
                    }

                    TableColumn("Type") { val in
                        Text(
                            "\(game.shipTypes[val.abbrev]!.name) (\(val.abbrev))"
                        )
                    }

                    TableColumn("Coord") { val in
                        Text("\(val.coords.toString(), default: "unknown")")
                    }.standardWidth()

                    TableColumn("Fleet") { val in
                        Text("\(val.fleet)")
                    }.standardWidth()

                    TableColumn("Mob") { val in Text("\(val.mob)") }
                        .standardWidth()

                    TableColumn("Eff") { val in Text("\(val.eff)%") }
                        .standardWidth()

                    TableColumn("Notes") { val in
                        Text("\(val.cargoString())")
                    }
                }
                .onChange(of: selectedShip) {
                    centerCoord = game.ships[selectedShip!]!.coords
                }

                if selectedShip != nil {
                    if let shipNum = selectedShip, game.ships[shipNum] != nil {
                        Divider()
                        ShipDetailView(game: game, selectedShip: selectedShip)
                    } else {
                        Text("Ship doesn't exist")
                    }
                }
            }
        }
                .navigationSplitViewColumnWidth(min: 400, ideal: 800)
        .task {
            await game.cmd_ldump()  // Get land units at the same location / cargo
        }
    }
}
