//
//  cmd_fortify.swift
//  EmpireClient
//
//  Created by Dougal Scott on 3/10/2026.
//  See https://www.empire.cx/infopages/fortify.html

import Foundation

extension Game {
    // fortify <UNITS> <MOBILITY>
    func cmd_fortify(
        unit: LandUnit,
        mobility: Int,
    ) async {
        let _ = await runCmd("fortify \(unit.number) \(mobility)")
    }
}
