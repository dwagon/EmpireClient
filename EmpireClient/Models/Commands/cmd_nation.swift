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
        let result = await client.run_cmd("nation")
        guard result != [] else {
            print("nation returned empty")
            return
        }
        nationReport = result
    }
}
