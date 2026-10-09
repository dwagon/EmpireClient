//
//  cmd_ldump.swift //  EmpireClient
//
//  Created by Dougal Scott on 14/9/2026.
//  See https://www.empire.cx/infopages/ldump.html
import Foundation

extension Game {
    func cmd_ldump(_ arg: String = "*") async {
        let result = await runCmd("ldump \(arg)", suppressLog: true)
        guard result != [] else {
            log("ldump returned empty")
            return
        }
        parse_cmd_ldump(result, trimMissing: arg == "*")
    }

    func cmd_ldump(_ unit: LandUnit) async {
        let result = await runCmd("ldump \(unit.number)", suppressLog: true)
        guard result != [] else {
            log("ldump returned empty")
            return
        }
        parse_cmd_ldump(result, trimMissing: false)
    }

    //    Mon Sep 14 17:29:40 2026
    //    DUMP LAND UNITS 1789370980
    //    id type x y army eff mil fort mob food
    //          fuel tech retr react xl nland land ship shell gun
    //          petrol iron dust bar oil lcm hcm rad att def
    //          vul spd vis spy radius frg acc dam amm aaf
    //          uw civ
    //    0 cav  -1 1 ~ 10 0 0 0 0 0 119 42 0 0 0 -1 -1 0 0 0 0 0 0 0 0 0 0 1.65 0.69 71 38 18 4 3 0 0 0 0 0 0 0
    //    1 unit
    func parse_cmd_ldump(_ input: [String], trimMissing: Bool = true) {
        var lunit: LandUnit
        var exists: Set<LandNum> = []

        let expectedFieldCount = 42

        for line in input {
            let bits = line.split(whereSeparator: \.isWhitespace)
            guard !bits.isEmpty else {
                continue
            }
            guard bits.count == expectedFieldCount else {
                continue
            }

            if bits[0] == "id" { continue } // header

            guard let lunitNum = LandNum(bits[0]) else {
                print("Unknown line: \(line)")
                continue
            }

            if let existing = landUnits[lunitNum] {
                lunit = existing
            } else {
                lunit = LandUnit(abbrev: String(bits[1]))
            }

            guard let x = Int(bits[2]), let y = Int(bits[3]),
                let eff = Int(bits[5]), let fortification = Int(bits[7]), let mob = Int(bits[8]), let tech = Int(bits[11]), let retreat = Int(bits[12]), let react = Int(bits[13]), let xl = Int(bits[14]), let nland = Int(bits[15]), let land = LandNum(bits[16]), let ship = Int(bits[17]), let attack = Float(bits[28]), let defense = Float(bits[29]), let vulnerability = Int(bits[30]), let speed = Int(bits[31])
            else {
                print("Bad line: \(line)")
                continue
            }

            lunit.number = lunitNum
            lunit.abbrev = String(bits[1])
            lunit.coords = MapCoord(x: x, y: y)
            lunit.army = String(bits[4])
            lunit.eff = eff
            lunit.cargo[.mil] = Int(bits[6])
            lunit.fortification = fortification
            lunit.mob = mob
            lunit.cargo[.food] = Int(bits[9])
            // ship.fuel = Int(bits[10])!   // Obsolete
            lunit.tech = tech
            lunit.retreat = retreat
            lunit.react = react
            lunit.xl = xl
            lunit.nland = nland
            lunit.land = land
            lunit.ship = ship
            lunit.cargo[.shells] = Int(bits[18])
            lunit.cargo[.guns] = Int(bits[19])
            lunit.cargo[.petrol] = Int(bits[20])
            lunit.cargo[.ironOre] = Int(bits[21])
            lunit.cargo[.goldDust] = Int(bits[22])
            lunit.cargo[.goldBars] = Int(bits[23])
            lunit.cargo[.oil] = Int(bits[24])
            lunit.cargo[.lcm] = Int(bits[25])
            lunit.cargo[.hcm] = Int(bits[26])
            lunit.cargo[.radioactives] = Int(bits[27])
            lunit.attack = attack
            lunit.defense = defense
            lunit.vulnerability = vulnerability
            lunit.speed = speed
            lunit.visibility = Int(bits[32])!
            lunit.spy = Int(bits[33])!
            lunit.radius = Int(bits[34])!
            lunit.frg = Int(bits[35])!
            lunit.accuracy = Int(bits[36])!
            lunit.damage = Int(bits[37])!
            lunit.ammoUse = Int(bits[38])!
            lunit.aaf = Int(bits[39])!
            lunit.cargo[.uw] = Int(bits[40])
            lunit.cargo[.civ] = Int(bits[41])

            landUnits[lunitNum] = lunit
            exists.insert(lunitNum)
        }

        // Remove units that weren't in the dump
        for lunit in Array(landUnits.keys) {
            if !exists.contains(lunit) && trimMissing {
                landUnits.removeValue(forKey: lunit)
            }
        }
    }
}
