//
//  cmd_assault.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/8/2026.
//  See https://www.empire.cx/infopages/assault.html

import Foundation

extension Game {
    func cmd_assault(sector: MapCoord, ship: Ship) async -> [String]{
        let result = await runCmd("assault \(sector.toString()) \(ship.number)")
        return result
    }
}
