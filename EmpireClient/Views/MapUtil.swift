//
//  DirectionString.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/8/2026.
//

import HexGrid
import SwiftUI

func directionString(_ cell: Cell) -> String {
    let coord = cell.coordinates
    switch (coord.x, coord.y) {
    case (1, 0):
        return "u"
    case (1, -1):
        return "j"
    case (0, -1):
        return "n"
    case (0, 0):
        return "h"
    case (0, 1):
        return "y"
    case (-1, 1):
        return "g"
    case (-1, 0):
        return "b"
    default:
        return "\(coord.x),\(coord.y)"
    }
}

// Generic cell colour for maps
func mapCellColour(cell: Cell, gameMap: Map, hexmap: HexGrid, center: MapCoord) -> GraphicsContext.Shading {
    do {
        if cell == hexmap.cellAt(try CubeCoordinates(x: 0, y: 0, z: 0))! {
            return .color(Color.orange)
        }
    } catch { print("cellColour: No center of hexmap") }
    let mapCoord = screenToMapCoord(
        cell.coordinates,
        centerCoord: center
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

/// Adjust screen coordinates to map coordinates
func screenToMapCoord(_ coord: CubeCoordinates, centerCoord: MapCoord) -> MapCoord {
    var adjusted = MapCoord(coord)
    adjusted.x += centerCoord.x
    adjusted.y += centerCoord.y
    return adjusted
}
