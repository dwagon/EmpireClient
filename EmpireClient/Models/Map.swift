//
//  Map.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation

struct Map {
    private var map_data: [MapCoord:Sector] = [:]
    private var x_size: Int
    private var y_size: Int

    init(x_size: Int = 64, y_size: Int = 32) {
        self.x_size = x_size
        self.y_size = y_size
    }

    func sector(_ coordinates: MapCoord) -> Sector? {
        if validCoord(coordinates) {
            print("sector=\(coordinates)")
            return map_data[coordinates]!
        }
        return nil
    }

    subscript(key: MapCoord) -> Sector? {
        get {
            return map_data[key]
        }
        set {
            map_data[key] = newValue
        }
    }

    func validCoord(_ coordinates: MapCoord) -> Bool {
        return map_data.contains { $0.key == coordinates }
    }
}


// MARK: -
struct InvalidCoordinate: Error {
    var message: String
}


