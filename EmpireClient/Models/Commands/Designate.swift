//
//  Desig.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/8/2026.
//

import Foundation

extension Game {
    func cmd_desig(
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
        let cmd_string =
        "explo \(itemstr) \(sector.x),\(sector.y) \(number) \(destination)"
        print("cmd_string = '\(cmd_string)'")
        let result = await client.run_cmd(cmd_string)
        guard result != [] else {
            print("explo returned empty")
            return
        }
        print("explo result=\n\(result)")
    }
}
