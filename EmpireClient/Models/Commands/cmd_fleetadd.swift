//
//  cmd_fleetadd.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/9/2026.
//  See https://www.empire.cx/infopages/fleetadd.html

import Foundation

extension Game {
    // fleetadd <FLEET> <SHIP/FLEET>
    func cmd_fleetadd(
        fleet: String,
        ship: Ship,
    ) async {
        let fleet = fleet.isEmpty ? "~" : fleet
        let _ = await runCmd("fleetadd \(fleet) \(ship.number)")
    }
}
