//
//  Explore.swift
//  EmpireClient
//
//  Created by Dougal Scott on 12/8/2026.
//

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
        let cmdString =
        "explo \(itemstr) \(sector.x),\(sector.y) \(number) \(destination)h"
        log(cmdString)
        let result = await client.run_cmd(cmdString)
        guard result != [] else {
            log("explo returned empty")
            return
        }
        log(result)
    }
}
