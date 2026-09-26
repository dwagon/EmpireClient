//
//  NukeDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 26/9/2026.
//

import SwiftUI

struct NukeDetailView: View {
    @State var game: Game
    @Binding var centerCoord: MapCoord
    @State private var selectedNuke: Nuke.ID?

    var body: some View {
        let minColWidth: CGFloat = 60
        let idealColWidth: CGFloat = 80
        let maxColWidth: CGFloat = 100
        HStack {
            VStack {
                Table(game.nukeTable, selection: $selectedNuke) {
                    TableColumn("Nuke #") { val in
                        Text("\(val.number)")
                    }
                    .width(
                        min: minColWidth,
                        ideal: idealColWidth,
                        max: maxColWidth
                    )
                    TableColumn("Type") { val in
                        Text(
                            "\(game.nukeTypes[val.abbrev]!.name) (\(val.abbrev))"
                        )
                    }
                    TableColumn("Coord") { val in
                        Text("\(val.coords.toString(), default: "unknown")")
                    }.width(
                        min: minColWidth,
                        ideal: idealColWidth,
                        max: maxColWidth
                    )

                }
                .onChange(of: selectedNuke) {
                    centerCoord = game.nukes[selectedNuke!]!.coords
                }
                if let nukeNum = selectedNuke {
                    if let _ = game.nukes[nukeNum] {
                        Divider()
                        nukeDetails
                    }
                    else {
                        Divider()
                        Text("Nuke doesn't exist")
                    }
                }
            }
            nukeButtonBar
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
    }

    var nukeButtonBar: some View {
        VStack {
            refreshButton

            if selectedNuke != nil {
                // TODO
            }
        }
    }

    var nukeDetails: some View {
        let nukeNum = selectedNuke!
        let nuke = game.nukes[nukeNum]!
        let nukeType = game.nukeTypes[nuke.abbrev]!

        return VStack(alignment: .leading) {
            HStack {
                Text("Nuke \(nukeNum)")
                Text("\(nukeType.name.capitalized)").bold()
                Text("'\(nukeType.abbrev)'")
            }
            HStack {
                Text("Blast: \(nukeType.blast)")
                Text("Damage: \(nukeType.damage)")
                Text("Weight: \(nukeType.lbs)")
            }
            Text("Capabilities: \(nukeType.capabilities)")
            Divider()
        }.padding()
            .border(.blue)
    }

    var refreshButton: some View {
        return
            Button("Refresh") {
                Task {
                    await game.cmd_map()
                    await game.cmd_ndump()
                }
            }
    }

}

#Preview {
    @Previewable @State var game = DataLoader.loadSampleGame(
        name: "Game_ShipView"
    )
    @Previewable @State var centerCoord = MapCoord(x: 0, y: 0)
    NukeDetailView(game: game, centerCoord: $centerCoord)

}
