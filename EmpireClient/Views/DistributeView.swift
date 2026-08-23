//
//  DistributeView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 17/8/2026.
//

import HexGrid
import SwiftUI

enum DistributeOption {
    case set
    case unset
    case ignore
}

struct View_Distribute: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var center_coord: MapCoord
    @State var option: DistributeOption = .ignore
    @State var destination: MapCoord? = nil
    @State var isEverywhere: Bool = true

    func body(content: Content) -> some View {
        let sectors = game.game_map.instances(.warehouse)

        return
            content
            .sheet(
                isPresented: $isPresented
            ) {
                isPresented = false
                switch option {
                case .set:
                    Task {
                        if isEverywhere {
                            await game.cmd_distribute(
                                destination: destination!
                            )
                        } else {
                            await game.cmd_distribute(
                                source: center_coord,
                                destination: destination!
                            )
                        }
                        await game.cmd_dump()
                    }
                case .unset:
                    Task {
                        await game.cmd_distribute(
                            source: center_coord,
                            destination: "."
                        )
                        await game.cmd_dump()
                    }
                case .ignore:
                    break
                }
            } content: {
                DistributeView(
                    coord: center_coord,
                    sectors: sectors,
                    option: $option,
                    destination: $destination,
                    isEverywhere: $isEverywhere
                )
            }

    }
}

extension View {
    func distribute(
        isPresented: Binding<Bool>,
        game: Game,
        center_coord: MapCoord
    ) -> some View {
        modifier(
            View_Distribute(
                isPresented: isPresented,
                game: game,
                center_coord: center_coord
            )
        )
    }
}

struct DistributeView: View {
    var coord: MapCoord
    var sectors: [Sector]  // Warehouse sectors
    @Binding var option: DistributeOption
    @Binding var destination: MapCoord?
    @Binding var isEverywhere: Bool

    @State private var cancelDistribution: Bool = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Label(
                "Set distribution",
                systemImage: "arrow.down.forward.and.arrow.up.backward"
            ).font(.title)

            if !cancelDistribution {
                Toggle(
                    "Set for everywhere not just \(coord.toString())",
                    isOn: $isEverywhere
                )
                if sectors.isEmpty {
                    Text("No warehouse designated")
                } else {
                    Picker(
                        "Distribute to warehouse",
                        selection: $destination,
                        content: {
                            ForEach(sectors) { sector in
                                Text("\(sector.coords.toString())").tag(
                                    sector.coords
                                )
                            }
                        }
                    )
                    .pickerStyle(.segmented)
                    .padding()
                }
            }
            Toggle("Cancel distribution", isOn: $cancelDistribution)

            if cancelDistribution {
                Text("Cancel distribution at \(coord.toString())")
            } else {
                Text(
                    "Set distribution \(isEverywhere ? "of everywhere" : "at \(coord.toString())") to \(destination?.toString(), default: "nowhere")"
                )
            }
            Spacer()

            HStack {
                Button("Cancel", role: .cancel) {
                    option = .ignore
                    dismiss()
                }.padding()

                Button("Distribute") {
                    option = cancelDistribution ? .unset : .set
                    dismiss()
                }
                .buttonStyle(.automatic)
                .padding()

            }
        }
    }
}

// MARK: Preview
#Preview {
    @Previewable var sectors = [
        Sector(coords: MapCoord(x: 1, y: 1)),
        Sector(coords: MapCoord(x: -1, y: -1)),
    ]
    @Previewable var coord = MapCoord(x: 0, y: 0)
    @Previewable @State var option = DistributeOption.ignore
    @Previewable @State var destination: MapCoord? = nil
    @Previewable @State var isEverywhere: Bool = true

    DistributeView(
        coord: coord,
        sectors: sectors,
        option: $option,
        destination: $destination,
        isEverywhere: $isEverywhere
    )
}
