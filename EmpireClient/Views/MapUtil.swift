//
//  DirectionString.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/8/2026.
//

import HexGrid

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

/// Adjust screen coordinates to map coordinates
func screenToMapCoord(_ coord: CubeCoordinates, centerCoord: MapCoord) -> MapCoord {
    var adjusted = MapCoord(coord)
    adjusted.x += centerCoord.x
    adjusted.y += centerCoord.y
    return adjusted
}
