//
//  cmd_march.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/9/2026.
//  See https://www.empire.cx/infopages/march.html

import Foundation


extension Game {
    func cmd_march(
        unit: String,
        destination: MapCoord
    ) async {
        let cmdString =
            "march \(unit) \(destination.toString())"
        log(cmdString)
        let result = await client.runCmd(cmdString)
        guard result != [] else {
            log("march returned empty")
            return
        }
        log(result)
    }
}
