//
//  DistributeView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 17/8/2026.
//

import SwiftUI

enum DistributeSource: Hashable {
    case none
    case global
    case sector(MapCoord)
}

struct DistributeView: View {
    var game: Game
    var sector: Sector
    @Binding var viewMode: SectorViewMode

    @State var warehouses: [Sector]  // Warehouse sectors
    @State var source: DistributeSource
    @State var destination: MapCoord?

    init(game: Game, sector: Sector, viewMode: Binding<SectorViewMode>) {
        self.game = game
        self.sector = sector
        self._viewMode = viewMode
        self.warehouses = game.gameMap.instances(.warehouse)
        self.source = .none
        print("whouses=\(self.warehouses) wh=\(game.gameMap.instances(.warehouse))")
    }

    var body: some View {
        VStack {
            Label(
                "Set distribution",
                systemImage: "arrow.down.forward.and.arrow.up.backward"
            ).font(.title)
                .padding()

            HStack {
                VStack {
                    Text("From")
                    Picker(
                        selection: $source
                    ) {
                        Text("Everywhere").tag(DistributeSource.global)
                        Text("Just \(sector.coords.toString())").tag(
                            DistributeSource.sector(sector.coords)
                        )
                    } label: {
                        Text("")
                    }
                    .pickerStyle(.radioGroup)
                }

                VStack {
                    Text("Distribute to")
                    Text("which warehouse")
                    Picker(
                        selection: $destination
                    ) {
                        Text("Stop Distribution").tag(MapCoord?(nil))
                        ForEach(warehouses) { whouse in
                            Text("\(whouse.coords.toString())").tag(
                                whouse.coords
                            )
                        }
                    } label: {
                        Text("")
                    }
                    .pickerStyle(.radioGroup)
                }
            }
            HStack {
                CancelButton {
                    viewMode = .overview
                }
                OkButton("Distribute") {
                    doDistribute(
                        game: game,
                        coord: sector.coords,
                        source: source,
                        destination: destination
                    )
                    viewMode = .overview
                }.disabled(source == .none)
            }
        }.padding()

    }
}

func doDistribute(
    game: Game,
    coord: MapCoord,
    source: DistributeSource,
    destination: MapCoord?
) {
    if let destination {
        switch source {
        case .none:
            break
        case .global:
            Task {
                await game.cmd_distribute(destination: destination)
                await game.cmd_dump()
            }
        case .sector(let sector):
            Task {
                await game.cmd_distribute(
                    source: sector,
                    destination: destination
                )
                await game.cmd_dump(sector)
            }
        }
    } else {
        switch source {
        case .none:
            break
        case .global:
            Task {
                await game.cmd_distribute(destination: ".")
                await game.cmd_dump()
            }
        case .sector(let sector):
            Task {
                await game.cmd_distribute(source: sector, destination: ".")
                await game.cmd_dump(sector)
            }
        }
    }
}
