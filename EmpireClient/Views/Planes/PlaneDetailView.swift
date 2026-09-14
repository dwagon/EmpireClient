//
//  PlaneDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 13/9/2026.
//

import SwiftUI

struct PlaneDetailView: View {
    @State var game: Game
    @Binding var centerCoord: MapCoord
    @State private var selectedPlane: Plane.ID?

    var body: some View {
        let minColWidth: CGFloat = 60
        let idealColWidth: CGFloat = 80
        let maxColWidth: CGFloat = 100
        HStack {
            VStack {
                Table(game.planeTable, selection: $selectedPlane) {
                    TableColumn("Plane #") { val in
                        Text("\(val.number)")
                    }
                    .width(
                        min: minColWidth,
                        ideal: idealColWidth,
                        max: maxColWidth
                    )
                    TableColumn("Type") { val in
                        Text(
                            "\(game.planeTypes[val.abbrev]!.name) (\(val.abbrev))"
                        )
                    }
                    TableColumn("Coord") { val in
                        Text("\(val.coords.toString(), default: "unknown")")
                    }.width(
                        min: minColWidth,
                        ideal: idealColWidth,
                        max: maxColWidth
                    )

                    TableColumn("Mob") { val in Text("\(val.mob)") }.width(
                        min: minColWidth,
                        ideal: idealColWidth,
                        max: maxColWidth
                    )
                    TableColumn("Eff") { val in Text("\(val.eff)%") }.width(
                        min: minColWidth,
                        ideal: idealColWidth,
                        max: maxColWidth
                    )
                }
                .onChange(of: selectedPlane) {
                    centerCoord = game.planes[selectedPlane!]!.coords
                }
                if selectedPlane != nil {
                    Divider()
                    planeDetails
                }
            }
            planeButtonBar
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
    }

    var planeButtonBar: some View {
        VStack {
            refreshButton

            if selectedPlane != nil {
                // TODO
            }
        }
    }

    var planeDetails: some View {
        let planeNum = selectedPlane!
        let plane = game.planes[planeNum]!
        let planeType = game.planeTypes[plane.abbrev]!

        return VStack(alignment: .leading) {
            HStack {
                Text("Plane \(planeNum)")
                Text("\(planeType.name.capitalized)").bold()
                Text("'\(planeType.abbrev)'")
            }
            HStack {
                Text("Range: \(planeType.ran)")
                Text("Fuel: \(planeType.fuel)")
            }
            HStack {
                Text("Attack: \(planeType.att)")
                Text("Defense: \(planeType.def)")
            }
            Text("Capabilities: \(planeType.capabilities)")
            Divider()
        }.padding()
            .border(.blue)
    }

    var refreshButton: some View {
        return
            Button("Refresh") {
                Task {
                    await game.cmd_map()
                    await game.cmd_plane()
                }
            }
    }

}

#Preview {
    @Previewable @State var game = DataLoader.loadSampleGame(
        name: "Game_ShipView"
    )
    @Previewable @State var centerCoord = MapCoord(x: 0, y: 0)
    PlaneDetailView(game: game, centerCoord: $centerCoord)

}
