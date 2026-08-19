//
//  cmd_threshold.swift
//  EmpireClient
//
//  Created by Dougal Scott on 19/8/2026.
//  See https://www.empire.cx/infopages/threshold.html
//

import Foundation

extension Game {
    func cmd_threshold(
        item: Item,
        coord: MapCoord,
        level: Int
    ) async {
        let cmd_string = "thresh \(item) \(coord.x),\(coord.y) \(level)"
        log(cmd_string)
        let result = await client.run_cmd(cmd_string)
        log(result)
    }
}
