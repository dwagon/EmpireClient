//
//  Designate.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/8/2026.
//

import Foundation

extension Game {
    func cmd_designate(
        coord: MapCoord,
        designation: String
    ) async {
        let cmd_string =
        "designate \(coord.x),\(coord.y) \(designation)"
        print("cmd_string = '\(cmd_string)'")
        let result = await client.run_cmd(cmd_string)
        guard result != [] else {
            print("designate returned empty")
            return
        }
        print("designate result=\n\(result)")
    }
}
