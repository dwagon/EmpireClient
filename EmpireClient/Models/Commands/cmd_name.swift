//
//  cmd_name.swift
//  EmpireClient
//
//  Created by Dougal Scott on 17/9/2026.
//  See https://www.empire.cx/infopages/name.html

import Foundation

extension Game {
    // [##:##] Command : name <SHIPS> <NAME>
    func cmd_name(
        ship: String,
        name: String
    ) async {
        let cmdString =
            "name \(ship) \"\(name)\""
        log(cmdString)
        let result = await client.runCmd(cmdString)
        log(result)
    }
}
