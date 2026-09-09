//
//  cmd_power.swift
//  EmpireClient
//
//  Created by Dougal Scott on 9/9/2026.
//  See https://www.empire.cx/infopages/power.html

import Foundation

// - = [   Empire Power Report   ] = -
//  as of Tue Sep  8 11:31:29 2026
//
//          sects  eff civ  mil  shell gun pet  iron dust oil  pln ship unit money
//         1  30   24% 1.5K 110    0    0    0    0    0    0    0    0    0   24K
//           ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
// worldwide  30   24% 1.4K 100    0    0    0    0    0    0    0    0    0   25K

extension Game {
    func cmd_power() async {
        let result = await client.runCmd("power")
        guard result != [] else {
            print("power returned empty")
            return
        }
        powerReport = result
    }
}
