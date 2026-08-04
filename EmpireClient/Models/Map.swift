//
//  Map.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation

struct Map {
    var map_data: [MapCoord:Sector] = [:]
    var x_size: Int
    var y_size: Int

    init(x_size: Int = 64, y_size: Int = 32) {
        self.x_size = x_size
        self.y_size = y_size
        for i in -x_size/2...x_size/2 {
            for j in -y_size/2...y_size/2 {
                let coord = MapCoord(x: i, y: j)
                map_data[coord] = Sector(coords: coord)
            }
        }
    }

    func sector(_ coordinates: MapCoord) throws -> Sector {
        if validCoord(coordinates) {
            return map_data[coordinates]!
        }
        throw InvalidCoordinate(message: "Can't use \(coordinates) in sector() call")
    }

    func validCoord(_ coordinates: MapCoord) -> Bool {
        return map_data.contains { $0.key == coordinates }
    }
}


// MARK: -
struct InvalidCoordinate: Error {
    var message: String
}


