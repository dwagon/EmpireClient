//
//  cmd_assault.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/8/2026.
//  See https://www.empire.cx/infopages/assault.html

import Foundation

extension Game {
    func cmd_assault(sector: MapCoord, shipNum: String) async {
        let result = await client.run_cmd("assault \(sector) \(shipNum)")
        guard result != [] else {
            print("assault returned empty")
            return
        }
    }
}
