//
//  Map.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation

@Observable
class Map {
    private var map_data: [MapCoord:Sector] = [:]
    private var x_size: Int
    private var y_size: Int

    init(x_size: Int = 64, y_size: Int = 32) {
        self.x_size = x_size
        self.y_size = y_size
    }

    subscript(key: MapCoord) -> Sector? {
        get {
            return map_data[key]
        }
        set {
            map_data[key] = newValue
        }
    }

    func exists(_ coordinates: MapCoord) -> Bool {
        return map_data.contains { $0.key == coordinates }
    }

    /// Return a list of all instances of a particular sector designation
    func instances(_ desigtype: DesigType) -> [Sector] {
        let desig = Desig(desigtype)
        return map_data.values.filter { $0.desig == desig }
    }

    /// Check for
    func isValidCoord(_ coord: MapCoord) -> Bool {
        if coord.x < -self.x_size || coord.y < -self.y_size {
            return false
        }
        if coord.x > self.x_size || coord.y > self.y_size {
            return false
        }
        if coord.x % 2 != coord.y % 2 {
            return false
        }
        return true
    }
}
