//
//  cmd_radar.swift
//  EmpireClient
//
//  Created by Dougal Scott on 24/9/2026.
//  See https://www.empire.cx/infopages/radar.html

import Foundation

extension Game {
    func cmd_radar(_ coord: MapCoord, suppressLog: Bool = false) async {
        let _ = await runCmd("radar \(coord.toString())", suppressLog: suppressLog)
    }
}
