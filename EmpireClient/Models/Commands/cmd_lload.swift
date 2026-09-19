//
//  cmd_lload.swift
//  EmpireClient
//
//  Created by Dougal Scott on 19/9/2026.
//  See https://www.empire.cx/infopages/lload.html

// [##:##] Command : lload <COMMODITY> <UNITS> <AMOUNT>
// [##:##] Command : lload plane <UNITS> <PLANES>
// [##:##] Command : lload land <UNITS> <UNITS>

import Foundation

extension Game {
    func cmd_lload(commodity: Item, unit: String, amount: Int) async {
        let _ = await runCmd("lload \(commodity.rawValue) \(unit) \(amount)")
    }
}
