//
//  NavigateView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 1/9/2026.
//

import HexGrid
import SwiftUI

struct NavigateView: View {
    var shipNum: String
    var game: Game
    @State var destination: MapCoord? = nil

    @Environment(\.dismiss) var dismiss

    var hexmap = HexGrid(
        shape: .hexagon(4),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize
    )

    var body: some View {
        VStack {
            Label(
                "Navigate Ship",
                systemImage: "arrow.up.and.down.and.arrow.left.and.right"
            )
            .font(
                .title
            )
            HStack {
                DrawHex(
                    hexmap: hexmap,
                    cellText: cellText,
                    cellFillColour: cellColour,
                    hexGesture: hexGesture
                ).scaledToFit()
                Text(
                    destination == nil ? "Navigate to a location from ship \(shipNum)" :
                    "Navigate to \(destination!.toString()) from ship \(shipNum)"
                )
            }
            HStack {
                Button("Finish") {
                    dismiss()
                }
            }.buttonStyle(.automatic)

        }
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            destination = cubeToDoubleWidth(
                from: cell.coordinates
            )
            destination! += game.ships[shipNum]!.coords
            Task {
                await game.cmd_navigate(
                    shipNum: shipNum,
                    destination: destination!
                )
                await game.cmd_map(cmdArg: shipNum)
            }
        } else {
            print("no cell at \(location.hexPoint)")
        }
    }

    func cellText(_ cell: Cell) -> String {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: game.ships[shipNum]!.coords
        )
        if let sector = game.gameMap[mapCoord] {
            return sector.symbol
        } else {
            return "\(mapCoord.toString())"
        }
    }

    func cellColour(_ cell: Cell) -> GraphicsContext.Shading {
        return mapCellColour(
            cell: cell,
            gameMap: game.gameMap,
            hexmap: hexmap,
            center: game.ships[shipNum]!.coords
        )
    }
}

struct NavigateShipSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var shipId: Ship.ID?
    @State var shipLocation: MapCoord = MapCoord(x: 0, y: 0)
    @State var destination: MapCoord = MapCoord(x: 0, y: 0)
    @State var response: [String] = []

    func body(content: Content) -> some View {
        if let shipId {
            content
                .sheet(
                    isPresented: $isPresented
                ) {
                    isPresented = false
                } content: {
                    NavigateView(
                        shipNum: game.ships[shipId]!.number,
                        game: game
                    )
                }
        } else {
            content
        }
    }
}

extension View {
    func navigateShip(
        isPresented: Binding<Bool>,
        game: Game,
        shipId: Ship.ID?
    ) -> some View {
        modifier(
            NavigateShipSheet(
                isPresented: isPresented,
                game: game,
                shipId: shipId
            )
        )
    }
}

//#Preview {
//    NavigateView()
//}
