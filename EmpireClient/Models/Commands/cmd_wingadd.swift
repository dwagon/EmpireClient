//
//  cmd_wingadd.swift
//  EmpireClient
//
//  Created by Dougal Scott on 2/10/2026.
//  See https://www.empire.cx/infopages/wingadd.html

import Foundation

extension Game {
    func cmd_wingadd(
        wing: String,
        plane: Plane,
    ) async {
        let wing = wing.isEmpty ? "~" : wing
        let _ = await runCmd("wingadd \(wing) \(plane.number)")
    }
}
