//
//  cmd_launch.swift
//  EmpireClient
//
//  Created by Dougal Scott on 4/10/2026.
//  See https://www.empire.cx/infopages/launch.html

import Foundation

extension Game {
    // launch <PLANES> <SECT|SHIP|PLANE>
    func cmd_launch(
        plane: Plane,
        dest: MapCoord,
        geosync: Bool
    ) async {
        let result = await runCmd("launch \(plane.number) \(dest.toString())")
        if result.isEmpty {
            return
        }
        if result.contains(where: { $0.contains("Geostationary orbit") }) {
            let _ = await runCmd(geosync ? "y" : "n")
        }
    }
}
