//
//  cmd_nation.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/8/2026.
//  See https://www.empire.cx/infopages/nation.html

import Foundation

// (#1) 1 Nation Report    Sat Aug 22 10:07:49 2026
// Nation status is ACTIVE     Bureaucratic Time Units: 627
// 100% eff capital at 0,0 has 260 civilians & 44 military
//  The treasury has $254986.00     Military reserves: 0
// Education..........  0.00       Happiness.......  0.00
// Technology.........  0.00       Research........  0.00
// Technology factor : 25.00%     Plague factor :   0.00%
//
// Max population : 1000
// Max safe population for civs/uws: 769/869
// No happiness needed

extension Game {
    func cmd_nation() async {
        let result = await client.runCmd("nation")
        guard result != [] else {
            print("nation returned empty")
            return
        }
        treasury = extract_treasury(from: result)
        techLevel = extract_tech(from: result)
        nationReport = result
    }

    func extract_treasury(from lines: [String]) -> Int {
        let regex = /The treasury has \$(\d+).00/
        for line in lines {
            if let match = line.firstMatch(of: regex) {
                let budget = match.1
                return Int(budget) ?? -2
            }
        }
        return -1
    }

    func extract_tech(from lines: [String]) -> Float {
        let regex = /Technology...* (\d+\.\d+)\s/
        for line in lines {
            if let match = line.firstMatch(of: regex) {
                let tech = match.1
                return Float(tech) ?? 0.0
            }
        }
        return 0.0
    }
}
