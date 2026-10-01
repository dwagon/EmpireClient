//
//  cmd_upgrade.swift
//  EmpireClient
//
//  Created by Dougal Scott on 2/10/2026.
//  See https://www.empire.cx/infopages/upgrade.html

import Foundation

extension Game {
    func cmd_upgrade(unit: LandUnit) async {
        let _ = await runCmd("upgrade l \(unit.number)")
    }

    func cmd_upgrade(plane: Plane) async {
        let _ = await runCmd("upgrade p \(plane.number)")
    }

    func cmd_upgrade(ship: Ship) async {
        let _ = await runCmd("upgrade s \(ship.number)")
    }
}
