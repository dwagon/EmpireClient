//
//  cmd_neweff.swift
//  EmpireClient
//
//  Created by Dougal Scott on 9/10/2026.
//  See https://www.empire.cx/infopages/neweff.html

// Fri Oct  9 11:10:03 2026
// EFFICIENCY SIMULATION
//   sect  des    projected eff
//  -1,-1   a     40%
//  -2,0    f      0%
//   0,0    c    100%
// ...
//   2,4    d      2%
// 19 sectors

import Foundation

extension Game {
    func cmd_neweff() async {
        let result = await runCmd("neweff *", suppressLog: true)
        parse_cmd_neweff(result)
    }
    func parse_cmd_neweff(_ input: [String]) {
        let expectedFieldCount = 3

        for line in input {
            let bits = line.split(whereSeparator: \.isWhitespace)
            guard !bits.isEmpty else { continue }
            guard bits.count == expectedFieldCount else { continue }
            guard bits[0] != "sect" else { continue }
            if let coords = MapCoord(String(bits[0])) {
                if let sector = gameMap[coords] {
                    sector.neweff = Int(bits[2].replacingOccurrences(of: "%", with: ""))
                }
            }
        }
    }
}


