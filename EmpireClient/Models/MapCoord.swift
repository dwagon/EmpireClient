//
//  MapCoord.swift
//  EmpireClient
//
//  Created by Dougal Scott on 4/8/2026.
//
import HexGrid

struct MapCoord: Hashable, Equatable {
    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    init(_ offset: OffsetCoordinates) {
        self.x = offset.column * 2
        self.y = offset.row
    }

    init(_ cube: CubeCoordinates) {
        self = cubeToDoubleWidth(from: cube, orientation: MapConfig.orientation, offsetLayout: MapConfig.offsetLayout)
    }

    func description() -> String {
        return "MapCoords(\(self.x), \(self.y))"
    }
}

//func doubleWidthToCube(from: OffsetCoordinates) throws
//    -> CubeCoordinates
//{
//    let q: Int = (from.column - from.row) / 2
//    let r: Int = from.row
//    let s: Int = -q - r
//    return try CubeCoordinates(x: q, y: r, z: s)
//}

func doubleWidthToCube(from: MapCoord) throws
    -> CubeCoordinates
{
    let q: Int = (from.x - from.y) / 2
    let r: Int = from.y
    let s: Int = -q - r
    return try CubeCoordinates(x: q, y: r, z: s)
}

func cubeToDoubleWidth(
    from: CubeCoordinates,
    orientation: Orientation,
    offsetLayout: OffsetLayout
) -> MapCoord {
    let col: Int = 2 * from.x + from.z
    let row: Int = from.z
    let offset = OffsetCoordinates(
        column: col,
        row: row,
        orientation: orientation,
        offsetLayout: offsetLayout
    )
    return MapCoord(x: offset.column, y: offset.row)
}
