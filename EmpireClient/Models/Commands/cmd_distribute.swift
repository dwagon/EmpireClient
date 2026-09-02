//
//  Distribute.swift
//  EmpireClient
//
//  Created by Dougal Scott on 17/8/2026.
//  See https://www.empire.cx/infopages/distribute.html

import Foundation

extension Game {
    /// Distribute a sector to another sector (e.g. warehouse)
    func cmd_distribute(
        source: MapCoord,
        destination: MapCoord
    ) async {
        let cmdString =
            "distribute \(source.toString()) \(destination.toString())"
        log(cmdString)
        let result = await client.runCmd(cmdString)
        log(result)
    }

    /// Can be used to stop distribution if destination is '.' or 'h'
    func cmd_distribute(
        source: MapCoord,
        destination: String
    ) async {
        let cmdString = "distribute \(source.toString()) \(destination)"
        log(cmdString)
        let result = await client.runCmd(cmdString)
        log(result)
    }

    /// Set everywhere with '#'
    func cmd_distribute(
        destination: MapCoord
    ) async {
        let cmdString = "distribute # \(destination.toString())"
        log(cmdString)
        let result = await client.runCmd(cmdString)
        log(result)
    }
}
