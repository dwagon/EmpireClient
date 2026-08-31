//
//  cmd_load.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/8/2026.
//  See https://www.empire.cx/infopages/load.html

import Foundation

extension Game {
    func cmd_load(commodity: Item, shipNum: String, amount: Int) async {
        let cmdString = "load \(commodity) \(shipNum) \(amount)"
        let result = await client.run_cmd(cmdString)
        guard result != [] else {
            print("load returned empty")
            return
        }
        log(result)
    }
}
