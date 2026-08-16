//
//  Designate.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/8/2026.
//  See https://www.empire.cx/infopages/designate.html
//

import Foundation

extension Game {
    func cmd_designate(
        coord: MapCoord,
        designation: String
    ) async {
        let cmd_string =
            "designate \(coord.x),\(coord.y) \(designation)"
        log("cmd_string = '\(cmd_string)'")
        let result = await client.run_cmd(cmd_string)
        log(result)
    }
}
