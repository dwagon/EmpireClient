//
//  DoubleWidth.swift
//  Convert to/from double width hex grid coordinates
//
//  Created by Dougal Scott on 2/8/2026.
//
import HexGrid

func doubleWidthToCube(from: OffsetCoordinates) throws
    -> CubeCoordinates
{
    let q: Int = (from.column - from.row) / 2
    let r: Int = from.row
    let s: Int = -q - r
    return try CubeCoordinates(x: q, y: r, z: s)
}

func cubeToDoubleWidth(
    from: CubeCoordinates,
    orientation: Orientation,
    offsetLayout: OffsetLayout
) throws -> OffsetCoordinates {
    let col: Int = 2 * from.x + from.y
    let row: Int = from.y
    return OffsetCoordinates(
        column: col,
        row: row,
        orientation: orientation,
        offsetLayout: offsetLayout
    )
}
