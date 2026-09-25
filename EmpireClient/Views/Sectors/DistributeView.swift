//
//  DistributeView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 17/8/2026.
//

import SwiftUI

enum DistributeSource: Hashable {
    case global
    case sector(MapCoord)
}

struct DistributeView: View {
    var coord: MapCoord
    var warehouses: [Sector]  // Warehouse sectors
    @Binding var source: DistributeSource
    @Binding var destination: MapCoord?
    var onButton: () -> Void
    @Environment(\.dismiss) var dismiss

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
                        Text("Just \(coord.toString())").tag(
                            DistributeSource.sector(coord)
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
        }.padding()
        HStack {
            CancelButton()
            OkButton("Distribute") {
                onButton()
            }
        }
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

struct DistributeSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var centerCoord: MapCoord
    @State var source: DistributeSource = .global
    @State var destination: MapCoord?

    func body(content: Content) -> some View {
        let warehouses = game.gameMap.instances(.warehouse)

        return
            content
            .sheet(
                isPresented: $isPresented
            ) {
                DistributeView(
                    coord: centerCoord,
                    warehouses: warehouses,
                    source: $source,
                    destination: $destination
                ) {
                    doDistribute(
                        game: game,
                        coord: centerCoord,
                        source: source,
                        destination: destination
                    )
                    source = .global
                    destination = nil
                }
            }
    }
}

extension View {
    func distribute(
        isPresented: Binding<Bool>,
        game: Game,
        centerCoord: MapCoord
    ) -> some View {
        modifier(
            DistributeSheet(
                isPresented: isPresented,
                game: game,
                centerCoord: centerCoord
            )
        )
    }
}

// MARK: Preview
#Preview {
    @Previewable var sectors = [
        Sector(coords: MapCoord(x: 1, y: 1)),
        Sector(coords: MapCoord(x: -1, y: -1)),
    ]
    @Previewable var coord = MapCoord(x: 0, y: 0)
    @Previewable @State var source = DistributeSource.global
    @Previewable @State var destination: MapCoord?

    DistributeView(
        coord: coord,
        warehouses: sectors,
        source: $source,
        destination: $destination
    ) {
        print("Set \(source) to \(destination, default: "nowhere")")
    }
}
