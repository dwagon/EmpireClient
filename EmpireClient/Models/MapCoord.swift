//
//  MapCoord.swift
//  EmpireClient
//
//  Created by Dougal Scott on 4/8/2026.
//


struct MapCoord: Hashable {
    var x: Int
    var y: Int

    func description() -> String {
        return "MapCoords(\(self.x), \(self.y))"
    }
}
