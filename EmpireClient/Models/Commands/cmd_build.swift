//
//  cmd_build.swift
//  EmpireClient
//  https://www.empire.cx/infopages/build.html
//
//  Created by Dougal Scott on 23/8/2026.
//

import Foundation

extension Game {
    // build [ship|plane|land|nuke] <SECTS> TYPE [NUMBER] [TECH] [SURE?]
    func cmd_build(
        device: BuildType,
        type: String,
        sector: MapCoord,
        number: Int = 1
    ) async {
        let cmdString =
            "build \(device.abbrev) \(sector.toString()) \(type) \(number)"
        log(cmdString)
        let result = await client.runCmd(cmdString)
        log(result)
    }
}
