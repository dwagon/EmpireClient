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
        let cmdString = "thresh \(item) \(coord.toString()) \(level)"
        log(cmdString)
        let result = await client.runCmd(cmdString)
        log(result)
    }

    func cmd_threshold(
        item: Item,
        level: Int
    ) async {
        let cmdString = "thresh \(item) # \(level)"
        log(cmdString)
        let result = await client.runCmd(cmdString)
        log(result)
    }

    /// Set thresholds for all sectors of the specified designation
    func cmd_threshold(
        item: Item,
        desig: Desig,
        level: Int
    ) async {
        let cmdString = "thresh \(item) ?des=\(desig.abbrev) # \(level)"
        log(cmdString)
        let result = await client.runCmd(cmdString)
        log(result)
    }
}
