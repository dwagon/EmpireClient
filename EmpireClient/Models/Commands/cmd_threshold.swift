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
        let _ = await runCmd("thresh \(item.rawValue) \(coord.toString()) \(level)")
    }

    func cmd_threshold(
        item: Item,
        level: Int
    ) async {
        let _ = await runCmd("thresh \(item.rawValue) * \(level)")
    }

    /// Set thresholds for all sectors of the specified designation
    func cmd_threshold(
        item: Item,
        desig: Desig,
        level: Int
    ) async {
        let _ = await runCmd("thresh \(item.rawValue) ?des=\(desig.abbrev) * \(level)")
    }

    func cmd_threshold(
        item: String,
        coord: MapCoord,
        level: Int
    ) async {
        let _ = await runCmd("thresh \(item) \(coord.toString()) \(level)")
    }
}
