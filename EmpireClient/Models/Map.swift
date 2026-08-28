//
//  Map.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation

@Observable
class Map {
    private var mapData: [MapCoord: Sector] = [:]
    private var xSize: Int
    private var ySize: Int

    init(xSize: Int = 64, ySize: Int = 32) {
        self.xSize = xSize
        self.ySize = ySize
    }

    subscript(key: MapCoord) -> Sector? {
        get {
            return mapData[key]
        }
        set {
            mapData[key] = newValue
        }
    }

    func exists(_ coordinates: MapCoord) -> Bool {
        return mapData.contains { $0.key == coordinates }
    }

    /// Return a list of all instances of a particular sector designation
    func instances(_ desigtype: DesigType) -> [Sector] {
        let desig = Desig(desigtype)
        return mapData.values.filter { $0.desig == desig }
    }

    /// Check for
    func isValidCoord(_ coord: MapCoord) -> Bool {
        if coord.x < -self.xSize || coord.y < -self.ySize {
            return false
        }
        if coord.x > self.xSize || coord.y > self.ySize {
            return false
        }
        if coord.x % 2 != coord.y % 2 {
            return false
        }
        return true
    }
}
