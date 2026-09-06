//
//  Explore.swift
//  EmpireClient
//
//  Created by Dougal Scott on 12/8/2026.
//  See https://www.empire.cx/infopages/explore.html

import Foundation

extension Game {
    func cmd_explo(
        item: Item,
        sector: MapCoord,
        number: Int,
        destination: String
    ) async {
        var itemstr: String

        switch item {
        case .civ: itemstr = "c"
        case .mil: itemstr = "m"
        default:
            print("Invalid explore item \(item) - has to be civ or mil")
            return
        }
        // Annoyingly you can't specify the destination as a coord if you don't own the destination (as in you are exploring)!
        let cmdString =
            "explo \(itemstr) \(sector.toString()) \(number) \(destination)h"
        log(cmdString)
        let result = await client.runCmd(cmdString)
        guard result != [] else {
            log("explo returned empty")
            return
        }
        log(result)
    }
}
