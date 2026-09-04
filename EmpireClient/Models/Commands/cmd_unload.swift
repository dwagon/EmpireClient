//
//  cmd_unload.swift
//  EmpireClient
//
//  Created by Dougal Scott on 4/9/2026.
//  See https://www.empire.cx/infopages/unload.html

import Foundation

extension Game {
    func cmd_unload(commodity: Item, shipNum: String, amount: Int) async {
        let cmdString = "unload \(commodity) \(shipNum) \(amount)"
        let result = await client.runCmd(cmdString)
        guard result != [] else {
            print("unload returned empty")
            return
        }
        log(result)
    }
}
