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
        let _ = await runCmd("distribute \(source.toString()) \(destination.toString())")
    }

    /// Can be used to stop distribution if destination is '.' or 'h'
    func cmd_distribute(
        source: MapCoord,
        destination: String
    ) async {
        let _ = await runCmd("distribute \(source.toString()) \(destination)")
    }

    /// Set everywhere with '#'
    func cmd_distribute(
        destination: MapCoord
    ) async {
        let _ = await runCmd("distribute * \(destination.toString())")
    }

    /// Manual everywhere with '#'
    func cmd_distribute(
        destination: String
    ) async {
        let _ = await runCmd("distribute * \(destination)")
    }
}
