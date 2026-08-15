//
//  MapView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import HexGrid
import SwiftUI

struct MapView: View {
    let game_map: Map
    @Binding var center_coord: MapCoord

    var hexmap = HexGrid(
        shape: .hexagon(MapConfig.mapRadius),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize
    )

    var body: some View {
        DrawHex(
            hexmap: hexmap,
            cellText: cellText,
            cellColour: cellColour,
            hexGesture: hexGesture
        )
    }

    func cellText(_ cell: Cell) -> String {
        let map_coord = screenToMapCoord(cell.coordinates)
        if let sector = game_map[map_coord] {
            return sector.symbol
        } else {
            return "\(map_coord.x),\(map_coord.y)"
        }
    }

    func cellColour(_ cell: Cell) -> GraphicsContext.Shading {
        do {
            if cell == hexmap.cellAt(try CubeCoordinates(x: 0, y: 0, z: 0))! {
                return .color(Color.red)
            }
        } catch { print("cellColour: No center of hexmap") }
        let map_coord = screenToMapCoord(cell.coordinates)
        if let sector = game_map[map_coord] {
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

    /// Adjust screen coordinates to map coordinates
    func screenToMapCoord(_ coord: CubeCoordinates) -> MapCoord {
        var adjusted = MapCoord(coord)
        adjusted.x += center_coord.x
        adjusted.y += center_coord.y
        return adjusted
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            let new_coord = cubeToDoubleWidth(
                from: cell.coordinates,
                orientation: MapConfig.orientation,
                offsetLayout: MapConfig.offsetLayout
            )
            center_coord.x += new_coord.x
            center_coord.y += new_coord.y
        }
        else {
            print("no cell at \(location.hexPoint)")
        }
    }
}


// MARK: -
#Preview {
    @Previewable var game = Game()
    @Previewable @State var center_coord = MapCoord(x: 0, y: 0)
    MapView(game_map: game.game_map, center_coord: $center_coord)
}
