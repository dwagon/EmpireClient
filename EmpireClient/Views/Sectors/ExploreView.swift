//
//  ExploreView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 11/8/2026.
//

import HexGrid
import SwiftUI

struct ExploreView: View {
    var game: Game
    var coord: MapCoord
    @Binding var item: Item
    @Binding var number: Int
    @Binding var destination: String?
    @State var destinationCell: Cell?

    @Environment(\.dismiss) var dismiss

    var hexmap = HexGrid(
        shape: .hexagon(4),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize
    )

    var body: some View {
        VStack {
            Label("Explore new territory", systemImage: "map.fill").font(.title)
            HStack {
                DrawHex(
                    hexmap: hexmap,
                    cellText: cellText,
                    cellFillColour: cellColour,
                    hexGesture: hexGesture
                ).scaledToFit()
                exploreDetails.padding()
                Spacer()
            }
            HStack {
                Button("Cancel", role: .cancel) {
                    number = 0
                    dismiss()
                }

                .buttonStyle(.automatic)
                .padding()
                Button("Explore") {
                    dismiss()
                }.disabled(destination == nil)
            }
        }
    }

    var exploreDetails: some View {
        return VStack {
            Picker(
                "Use",
                selection: $item,
                content: {
                    Text("Military (\(game[coord]!.cargo[.mil] ?? 0))").tag(
                        Item.mil
                    )
                    Text("Civilians (\(game[coord]!.cargo[.civ] ?? 0))").tag(
                        Item.civ
                    )
                }
            )
            .pickerStyle(.inline)
            .padding()
            let str =
                "Send \(number) "
                + ((item == Item.mil) ? "military" : "civilians")
            let max = game[coord]!.cargo[item] ?? 1
            Stepper(
                str,
                value: $number,
                in: 1...max
            )
        }
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            destination = directionString(cell)
            destinationCell = cell
        } else {
            print("no cell at \(location.hexPoint)")
        }
    }

    func cellText(_ cell: Cell) -> String {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: coord
        )
        if let sector = game.gameMap[mapCoord] {
            return sector.symbol
        } else {
            return "\(mapCoord.toString())"
        }
    }

    func cellColour(_ cell: Cell) -> GraphicsContext.Shading {
        if let destinationCell {
            if cell == destinationCell {
                return .color(Color.red)
            }
        }
        return mapCellColour(
            cell: cell,
            gameMap: game.gameMap,
            hexmap: hexmap,
            center: coord
        )
    }
}

struct ExploreSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var centerCoord: MapCoord
    @State private var item: Item = .mil
    @State private var number: Int = 1
    @State private var destination: String?

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                isPresented = false
                if number > 0 {
                    Task {
                        if let destination {
                            await game.cmd_explo(
                                item: item,
                                sector: centerCoord,
                                number: number,
                                destination: destination
                            )
                            await game.cmd_dump()
                            await game.cmd_map()
                        }
                        number = 0
                        item = .civ
                    }
                }
            } content: {
                ExploreView(
                    game: game,
                    coord: centerCoord,
                    item: $item,
                    number: $number,
                    destination: $destination
                )
            }
    }
}

extension View {
    func explore(
        isPresented: Binding<Bool>,
        game: Game,
        centerCoord: MapCoord
    ) -> some View {
        modifier(
            ExploreSheet(
                isPresented: isPresented,
                game: game,
                centerCoord: centerCoord
            )
        )
    }
}

#Preview {
    @Previewable var game = DataLoader.loadSampleGame(name: "Game_ShipView")
    @Previewable var coord = MapCoord(x: 0, y: 0)
    @Previewable @State var item: Item = .mil
    @Previewable @State var number: Int = 1
    @Previewable @State var destination: String?

    ExploreView(
        game: game,
        coord: coord,
        item: $item,
        number: $number,
        destination: $destination
    )
}
