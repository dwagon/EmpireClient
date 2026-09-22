//
//  cmd_march.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/9/2026.
//  See https://www.empire.cx/infopages/march.html

import Foundation


extension Game {
    func cmd_march(
        unit: LandUnit,
        destination: MapCoord
    ) async {
        let result = await runCmd("march \(unit.number) \(destination.toString())")
        guard result != [] else {
            log("march returned empty")
            return
        }
    }
}
