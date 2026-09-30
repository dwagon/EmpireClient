//
//  cmd_tend.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/9/2026.
//  See https://www.empire.cx/infopages/tend.html

import Foundation

extension Game {
    // tend <COMMODITY|'land'> <SHIP> <AMT|UNIT> <to-SHIP>
    func cmd_tend(
        commodity: Item,
        fromShip: Ship,
        amount: Int,
        toShip: Ship
    ) async {
        let _ = await runCmd("tend \(commodity.rawValue) \(fromShip.number) \(amount) \(toShip.number)")
    }
}
