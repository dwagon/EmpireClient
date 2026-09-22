//
//  cmd_load.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/8/2026.
//  See https://www.empire.cx/infopages/load.html

import Foundation

extension Game {
    func cmd_load(commodity: Item, ship: Ship, amount: Int) async {
        let result = await runCmd("load \(commodity) \(ship.number) \(amount)")
        guard result != [] else {
            print("load returned empty")
            return
        }
    }

    func cmd_load(landUnit: LandUnit, ship: Ship) async {
        let _ = await runCmd("load land \(ship.number) \(landUnit.number)")
    }
}
