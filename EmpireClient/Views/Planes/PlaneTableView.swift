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
    @State var sortOrder = [KeyPathComparator(\Plane.number)]
    @State private var planes: [Plane]

    init(
        game: Game,
        centerCoord: Binding<MapCoord>,
        selectedPlane: Binding<Plane.ID?>
    ) {
        self.game = game
        self._centerCoord = centerCoord
        self._selectedPlane = selectedPlane
        self.planes = Array(game.planes.values)
    }

    var body: some View {
        HStack {
            VStack {
                Table(
                    planes,
                    selection: $selectedPlane,
                    sortOrder: $sortOrder
                ) {
                    TableColumn("Plane #", value: \.number) { val in
                        Text("\(val.number)")
                    }
                    .standardWidth()
                    TableColumn("Type", value: \.abbrev) { val in
                        if let type = game.planeTypes[val.abbrev] {
                            Text(
                                "\(type.name) (\(val.abbrev))"
                            )
                        }
                        else {
                            Text("\(val.abbrev)")
                        }
                    }
                    TableColumn("Coord", value: \.coords) { val in
                        Text("\(val.coords.toString(), default: "unknown")")
                    }.standardWidth()

                    TableColumn("Wing", value: \.wing) { val in
                        Text("\(val.wing)")
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
                    guard let selectedPlane,
                        let plane = game.planes[selectedPlane]
                    else { return }
                    centerCoord = plane.coords
                }
                .onChange(of: sortOrder) { _, sortOrder in
                    planes.sort(using: sortOrder)
                }
            }
        }
    }
}
