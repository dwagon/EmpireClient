//
//  NavigateView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 1/9/2026.
//

import HexGrid
import SwiftUI

struct NavigateView: View {
    var ship: Ship
    var game: Game
    @State var destination: MapCoord?

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
                    radius: 5,
                    cellText: cellText,
                    cellFillColour: cellColour,
                    hexGesture: hexGesture
                ).scaledToFit()
                Text(
                    destination == nil
                    ? "Navigate to a location from ship \(ship.number)"
                    : "Navigate to \(destination!.toString()) from ship \(ship.number)"
                )
            }.padding()
            HStack {
                Button("Finish") {
                    dismiss()
                }
            }.buttonStyle(.automatic)
        }.padding()
    }

    func navigateToLocation(_ destination: MapCoord?) {
        Task {
            if let destination {
                await game.cmd_navigate(
                    ship: ship,
                    destination: destination
                )
                await game.cmd_sdump(ship)
                await game.cmd_map(cmdArg: String(ship.number))
            }
        }
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            destination = cubeToDoubleWidth(
                from: cell.coordinates
            )
            destination! += ship.coords
            navigateToLocation(destination)
        } else {
            print("no cell at \(location.hexPoint)")
        }
    }

    func cellText(_ cell: Cell) -> String {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: ship.coords
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
            center: ship.coords
        )
    }
}

struct NavigateShipSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var shipId: Ship.ID?

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                if let shipId, let ship = game.ships[shipId] {
                    NavigateView(
                        ship: ship,
                        game: game,
                    )
                }
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
