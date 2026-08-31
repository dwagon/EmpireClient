//
//  AssaultView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/8/2026.
//

import HexGrid
import SwiftUI

struct AssaultShipView: View {
    var shipNum: String
    var shipLocation: MapCoord
    var gameMap: Map
    @Binding var destination: MapCoord

    @Environment(\.dismiss) var dismiss

    var hexmap = HexGrid(
        shape: .hexagon(3),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize
    )

    var body: some View {
        VStack {
            Label("Assault from Ship", systemImage: "arrow.down.right.square")
                .font(
                    .title
                )
            DrawHex(
                hexmap: hexmap,
                cellText: cellText,
                cellFillColour: cellColour,
                hexGesture: hexGesture
            ).scaledToFit()
            Text("Assault \(destination.toString()) from ship \(shipNum)")
            HStack {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .buttonStyle(.automatic)
                .padding()
                Button("Assault") {
                    dismiss()
                }
            }
        }
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            destination = cubeToDoubleWidth(
                from: cell.coordinates,
                orientation: MapConfig.orientation,
                offsetLayout: MapConfig.offsetLayout
            )
            destination.x += shipLocation.x
            destination.y += shipLocation.y
        } else {
            print("no cell at \(location.hexPoint)")
        }
    }

    func cellText(_ cell: Cell) -> String {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: shipLocation
        )
        if let sector = gameMap[mapCoord] {
            return sector.symbol
        } else {
            return "\(mapCoord.toString())"
        }
    }

    func cellColour(_ cell: Cell) -> GraphicsContext.Shading {
        do {
            if cell == hexmap.cellAt(try CubeCoordinates(x: 0, y: 0, z: 0))! {
                return .color(Color.orange)
            }
        } catch { print("cellColour: No center of hexmap") }
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: shipLocation
        )
        if let sector = gameMap[mapCoord] {
            if sector.owned {
                return .color(Color.mint)
            }
            switch sector.desig.desig {
            case .sea:
                return .color(Color.blue)
            case .wilderness:
                return .color(Color.green)
            case .mountain:
                return .color(Color.gray)
            default:
                return .color(Color.clear)
            }
        }
        return .color(Color.clear)
    }
}

struct AssaultShipSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var shipId: Ship.ID?
    @State var shipLocation: MapCoord = MapCoord(x: 0, y: 0)
    @State var destination: MapCoord = MapCoord(x: 0, y: 0)

    func body(content: Content) -> some View {
        if let shipId {
            content
                .sheet(
                    isPresented: $isPresented
                ) {
                    isPresented = false
                    Task {
                        await game.cmd_assault(
                            sector: destination,
                            shipNum: game.ships[shipId]!.number,
                        )
                    }
                } content: {
                    AssaultShipView(
                        shipNum: game.ships[shipId]!.number,
                        shipLocation: game.ships[shipId]!.coords,
                        gameMap: game.gameMap,
                        destination: $destination
                    )
                }
        } else {
            content
        }
    }
}

extension View {
    func assaultShip(
        isPresented: Binding<Bool>,
        game: Game,
        shipId: Ship.ID?
    ) -> some View {
        modifier(
            AssaultShipSheet(
                isPresented: isPresented,
                game: game,
                shipId: shipId
            )
        )
    }
}

#Preview {
    @Previewable @State var coord = MapCoord(x: 0, y: 0)

    AssaultShipView(
        shipNum: "2",
        shipLocation: MapCoord(x: 2, y: 0),
        gameMap: Map(),
        destination: $coord
    )
}
