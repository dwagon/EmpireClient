//
//  Realm.swift
//  EmpireClient
//
//  Created by Dougal Scott on 25/9/2026.
//

import Foundation

class Realm: Decodable, Equatable {
    var minX: Int
    var minY: Int
    var maxX: Int
    var maxY: Int

    init?(_ str: String) {
        let regex = /(.*):(.*),(.*):(.*)/
        if let match = str.firstMatch(of: regex) {
            minX = Int(match.1)!
            maxX = Int(match.2)!
            minY = Int(match.3)!
            maxY = Int(match.4)!
        }
        else {
            return nil
        }
    }

    init(minX: Int, maxX: Int, minY: Int, maxY: Int) {
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
    }

    func inRealm(coord: MapCoord) -> Bool {
        return minX <= coord.x && coord.x <= maxX && minY <= coord.y && coord.y <= maxY
    }

    static func == (lhs: Realm, rhs: Realm) -> Bool {
        return lhs.minX == rhs.minX && lhs.minY == rhs.minY && lhs.maxX == rhs.maxX && lhs.maxY == rhs.maxY
    }
}
