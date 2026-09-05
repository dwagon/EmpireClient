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
    func cmd_ship(shipNum: String = "*") async {
        let result = await client.runCmd("ship \(shipNum)")
        guard result != [] else {
            log("ship returned empty")
            return
        }
        parse_ship_cmd(result)
    }

    func parse_ship_cmd(_ input: [String]) {
        let coordRegex = /(-*\d+),(-*\d+)/
        for line in input[1..<input.count - 1] {
            var ship: Ship
            let bits = line.split(separator: " ")
            let lastBit = bits.count
            let shipNum = String(bits[0])
            if ships[shipNum] == nil {
                ship = Ship(type: String(bits[1]))
            } else {
                ship = ships[shipNum]!
            }
            ship.number = shipNum
            ship.tech = Int(bits[lastBit - 1])!
            ship.mob = Int(bits[lastBit - 2])!
            ship.landUnits = Int(bits[lastBit - 3])!
            ship.xlPlanes = Int(bits[lastBit - 4])!
            ship.heli = Int(bits[lastBit - 5])!
            ship.planes = Int(bits[lastBit - 6])!
            ship.cargo[.food] = Int(bits[lastBit - 7])!
            ship.cargo[.uw] = Int(bits[lastBit - 8])!
            ship.cargo[.mil] = Int(bits[lastBit - 9])!
            ship.cargo[.civ] = Int(bits[lastBit - 10])!
            ship.eff = Int(bits[lastBit - 11].replacingOccurrences(of: "%", with: ""))!
            if let match = line.firstMatch(of: coordRegex) {
                ship.coords = MapCoord(String(match.0))!
            }
            ships[shipNum] = ship
        }
    }
}
