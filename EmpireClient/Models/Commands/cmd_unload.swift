//
//  cmd_unload.swift
//  EmpireClient
//
//  Created by Dougal Scott on 4/9/2026.
//  See https://www.empire.cx/infopages/unload.html

import Foundation

extension Game {
    func cmd_unload(commodity: Item, ship: Ship, amount: Int) async {
        let _ = await runCmd("unload \(commodity) \(ship.number) \(amount)")
    }

    func cmd_unload(landUnit: LandUnit, ship: Ship) async {
        let _ = await runCmd("unload land \(ship.number) \(landUnit.number)")
    }
}
