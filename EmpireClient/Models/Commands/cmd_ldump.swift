//
//  cmd_ldump.swift
//  EmpireClient
//
//  Created by Dougal Scott on 14/9/2026.
//  See https://www.empire.cx/infopages/ldump.html

import Foundation

extension Game {
    func cmd_ldump(unitNum: String = "*") async {
        let result = await client.runCmd("ldump \(unitNum)")
        guard result != [] else {
            log("ldump returned empty")
            return
        }
        parse_cmd_ldump(result)
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
    func parse_cmd_ldump(_ input: [String]) {
        var lunit: LandUnit
        var exists: Set<String> = []

        for line in input[3..<input.count - 1] {
            let bits = line.split(separator: " ")
            let lunitNum = String(bits[0])
            if landUnits[lunitNum] == nil {
                lunit = LandUnit(abbrev: String(bits[1]))
            } else {
                lunit = landUnits[lunitNum]!
            }
            lunit.number = String(bits[0])
            lunit.abbrev = String(bits[1])
            lunit.coords = MapCoord(x: Int(bits[2])!, y: Int(bits[3])!)
            lunit.army = String(bits[4])
            lunit.eff = Int(bits[5])!
            lunit.cargo[.mil] = Int(bits[6])
            lunit.fortification = Int(bits[7])!
            lunit.mob = Int(bits[8])!
            lunit.cargo[.food] = Int(bits[9])
            // ship.fuel = Int(bits[10])!   // Obsolete
            lunit.tech = Int(bits[11])!
            lunit.retreat = Int(bits[12])!
            lunit.react = Int(bits[13])!
            lunit.xl = Int(bits[14])!
            lunit.nland = Int(bits[15])!
            lunit.land = String(bits[16])
            lunit.ship = String(bits[17])
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
            lunit.attack = Float(bits[28])!
            lunit.defense = Float(bits[29])!
            lunit.vulnerability = Int(bits[30])!
            lunit.speed = Int(bits[31])!
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
        for lunit in landUnits.keys {
            if !exists.contains(lunit) {
                landUnits.removeValue(forKey: lunit)
            }
        }
    }
}
