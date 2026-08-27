//
//  cmd_ship.swift
//  EmpireClient
//
//  Created by Dougal Scott on 25/8/2026.
//  See https://www.empire.cx/infopages/ship.html
//
//    shp#     ship type       x,y   fl   eff civ mil  uw  fd pn he xl ln mob tech
//       0 dd  destroyer       1,1       100%   0   0   0   0  0  0  0  0 127  140
//       1 bb  battleship      1,1       100%   0   0   0   0  0  0  0  0 120  200
//    2 ships

import Foundation

extension Game {
    func cmd_ship() async {
        let result = await client.run_cmd("ship *")
        guard result != [] else {
            log("ship returned empty")
            return
        }
        let coord_reg = /(-*\d+),(-*\d+)/
        for line in result[1..<result.count - 1] {
            var ship: Ship
            let bits = line.split(separator: " ")
            let bl = bits.count
            let shipNum = String(bits[0])
            if ships[shipNum] == nil {
                ship = Ship(type: String(bits[1]))
            } else {
                ship = ships[shipNum]!
            }
            ship.tech = Int(bits[bl - 1])!
            ship.mob = Int(bits[bl - 2])!
            ship.landUnits = Int(bits[bl - 3])!
            ship.xlPlanes = Int(bits[bl - 4])!
            ship.heli = Int(bits[bl - 5])!
            ship.planes = Int(bits[bl - 6])!
            ship.food = Int(bits[bl - 7])!
            ship.uw = Int(bits[bl - 8])!
            ship.mil = Int(bits[bl - 9])!
            ship.civ = Int(bits[bl - 10])!
            ship.eff = Int(bits[bl - 11].replacingOccurrences(of: "%", with: ""))!
            if let match = line.firstMatch(of: coord_reg) {
                ship.coords = MapCoord(String(match.0))!
            }
            ships[shipNum] = ship
        }
    }
}
