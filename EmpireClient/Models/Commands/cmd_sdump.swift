//
//  cmd_sdump.swift
//  EmpireClient
//
//  Created by Dougal Scott on 14/9/2026.
//  See https://www.empire.cx/infopages/sdump.html

import Foundation

extension Game {
    func cmd_sdump(shipNum: String = "*") async {
        let result = await client.runCmd("sdump \(shipNum)")
        guard result != [] else {
            log("sdump returned empty")
            return
        }
        parse_cmd_sdump(result)
    }

    // DUMP SHIPS 1789346151
    // id type x y flt eff civ mil uw food pln he xl land mob fuel tech shell gun petrol iron dust bar oil lcm hcm rad def spd vis rng fir origx origy name
    // 0 frg  19 15 ~ 100 0 1 0 60 0 0 0 0 95 0 0 0 0 0 0 0 0 0 0 0 0 50 25 25 1 1 1 -3 "Boaty"
    // 1 fb   5 -3 ~ 100 300 0 0 413 0 0 0 0 -27 0 0 0 0 0 0 0 0 0 0 0 0 10 10 15 0 0 -1 5 ""
    // 2 fb   -12 -6 ~ 100 300 10 0 900 0 0 0 0 -28 0 0 0 0 0 0 0 0 0 0 0 0 10 10 15 0 0 1 -3 ""
    // 3 oe   0 6 ~ 100 10 0 0 100 0 0 0 0 127 0 105 0 0 0 0 0 0 1 0 0 0 11 29 12 0 0 -1 5 ""
    // 4 ships
    func parse_cmd_sdump(_ input: [String]) {
        var ship: Ship
        let quotesRegex = /"(.*)"/

        for line in input[3..<input.count - 1] {
            let bits = line.split(separator: " ")
            let shipNum = String(bits[0])
            if ships[shipNum] == nil {
                ship = Ship(abbrev: String(bits[1]))
            } else {
                ship = ships[shipNum]!
            }
            ship.number = String(bits[0])
            ship.abbrev = String(bits[1])
            ship.coords = MapCoord(x: Int(bits[2])!, y: Int(bits[3])!)
            ship.fleet = String(bits[4])
            ship.eff = Int(bits[5])!
            ship.cargo[.civ] = Int(bits[6])
            ship.cargo[.mil] = Int(bits[7])
            ship.cargo[.uw] = Int(bits[8])
            ship.cargo[.food] = Int(bits[9])
            ship.planes = Int(bits[10])!
            ship.heli = Int(bits[11])!
            ship.xlPlanes = Int(bits[12])!
            ship.landUnits = Int(bits[13])!
            ship.mob = Int(bits[14])!
            // ship.fuel = Int(bits[15])!   // Obsolete
            ship.tech = Int(bits[16])!
            ship.cargo[.shells] = Int(bits[17])
            ship.cargo[.guns] = Int(bits[18])
            ship.cargo[.petrol] = Int(bits[19])
            ship.cargo[.ironOre] = Int(bits[20])
            ship.cargo[.goldDust] = Int(bits[21])
            ship.cargo[.goldBars] = Int(bits[22])
            ship.cargo[.oil] = Int(bits[23])
            ship.cargo[.lcm] = Int(bits[24])
            ship.cargo[.hcm] = Int(bits[25])
            ship.cargo[.radioactives] = Int(bits[26])
            ship.defense = Int(bits[27])!
            ship.speed = Int(bits[28])!
            ship.visibility = Int(bits[29])!
            ship.range = Int(bits[30])!
            ship.fire = Int(bits[31])!
            // Orig_x = bits[32]
            // Orig_y = bits[33]
            if let match = line.firstMatch(of: quotesRegex) {
                ship.name = String(match.1)
            }
            ships[shipNum] = ship
        }
    }
}
