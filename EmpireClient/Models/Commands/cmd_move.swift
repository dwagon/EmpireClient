//
//  cmd_move.swift
//  EmpireClient
//
//  Created by Dougal Scott on 7/10/2026.
//  See https://www.empire.cx/infopages/move.html

import Foundation

// move <ITEM> <SECT> <NUMBER> <ROUTE|DESTINATION>
extension Game {
    func cmd_move(
        item: Item,
        sect: MapCoord,
        number: Int,
        destination: MapCoord
    ) async {
        let result = await runCmd("move \(item.rawValue) \(sect.toString()) \(number) \(destination.toString())")
        guard result != [] else {
            log("move returned empty")
            return
        }
    }
}
