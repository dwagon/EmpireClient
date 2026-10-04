//
//  PlaneTableView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 2/10/2026.
//

import SwiftUI

struct PlaneTableView: View {
    var game: Game
    @Binding var centerCoord: MapCoord
    @Binding var selectedPlane: Plane.ID?

    var body: some View {
        HStack {
            VStack {
                Table(game.planeTable, selection: $selectedPlane) {
                    TableColumn("Plane #") { val in
                        Text("\(val.number)")
                    }
                    .standardWidth()
                    TableColumn("Type") { val in
                        Text(
                            "\(game.planeTypes[val.abbrev]!.name) (\(val.abbrev))"
                        )
                    }
                    TableColumn("Coord") { val in
                        Text("\(val.coords.toString(), default: "unknown")")
                    }.standardWidth()

                    TableColumn("Wing") { val in Text("\(val.wing)") }
                        .standardWidth()

                    TableColumn("Mob") { val in Text("\(val.mob)") }
                        .standardWidth()
                    TableColumn("Eff") { val in Text("\(val.eff)%") }
                        .standardWidth()
                    TableColumn("Notes") { val in
                        HStack {
                            if val.launched == "Y" {
                                Text("Launched")
                            }
                            if val.orbit == "Y" {
                                Text("GeoOrbit")
                            }
                        }
                    }
                }
                .onChange(of: selectedPlane) {
                    guard let selectedPlane, let plane=game.planes[selectedPlane] else { return }
                    centerCoord = plane.coords
                }
            }
        }
    }
}
