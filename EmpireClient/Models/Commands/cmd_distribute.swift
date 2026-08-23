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
        let cmd_string =
            "distribute \(source.toString()) \(destination.toString())"
        log(cmd_string)
        let result = await client.run_cmd(cmd_string)
        log(result)
    }

    /// Can be used to stop distribution if destination is '.' or 'h'
    func cmd_distribute(
        source: MapCoord,
        destination: String
    ) async {
        let cmd_string = "distribute \(source.toString()) \(destination)"
        log(cmd_string)
        let result = await client.run_cmd(cmd_string)
        log(result)
    }

    /// Set everywhere with '#'
    func cmd_distribute(
        destination: MapCoord
    ) async {
        let cmd_string = "distribute # \(destination.toString())"
        log(cmd_string)
        let result = await client.run_cmd(cmd_string)
        log(result)
    }
}
