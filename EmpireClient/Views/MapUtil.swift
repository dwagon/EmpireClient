//
//  DirectionString.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/8/2026.
//

import HexGrid
import SwiftUI

func directionString(_ cell: Cell) -> String? {
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
        return nil
    }
}

func directionIcon(_ direction: String?) -> String? {
    if let direction {
        switch (direction) {
        case "u":
            return "arrow.up.right"
        case "j":
            return "arrow.right"
        case "n":
            return "arrow.down.right"
        case "h":
            return "arrow.2.squarepath"
        case ".":
            return "arrow.2.squarepath"
        case "y":
            return "arrow.up.and.backward"
        case "g":
            return "arrow.left"
        case "b":
            return "arrow.down.backward"
        default:
            return nil
        }
    }
    return nil
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
