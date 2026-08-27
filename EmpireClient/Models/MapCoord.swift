//
//  MapCoord.swift
//  EmpireClient
//
//  Created by Dougal Scott on 4/8/2026.
//
import HexGrid

struct MapCoord: Hashable, Equatable, Codable {
    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    /// initialise with e.g. "4,-2"
    init?(_ coord: String) {
        let bits = coord.split(separator: ",")
        self.init(x: String(bits[0]), y: String(bits[1]))
    }

    init?(x: String, y: String) {
        guard Int(x) != nil else {
            print("MapCoord x must be an number, not \(x)")
            return nil
        }
        guard Int(y) != nil else {
            print("MapCoord y must be an number, not \(x)")
            return nil
        }
        self.x = Int(x)!
        self.y = Int(y)!
    }

    init(_ offset: OffsetCoordinates) {
        self.x = offset.column * 2
        self.y = offset.row
    }

    init(_ cube: CubeCoordinates) {
        self = cubeToDoubleWidth(
            from: cube,
            orientation: MapConfig.orientation,
            offsetLayout: MapConfig.offsetLayout
        )
    }

    init?(x: MapKeyValue, y: MapKeyValue) {
        do {
            self.x = try x.toInt()
            self.y = try y.toInt()
        } catch {
            return nil
        }
    }

    func description() -> String {
        return "MapCoords(\(self.x), \(self.y))"
    }

    func toString() -> String {
        return "\(self.x),\(self.y)"
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
