//
//  cmd_show_nuke.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/9/2026.
//

import Foundation

extension Game {
    /// Find out all the details of nukes
    func cmd_show_nuke() async -> [String: NukeType] {
        let bResult = await runCmd("show nuke b", suppressLog: true)
        let sResult = await runCmd("show nuke s", suppressLog: true)

        if bResult.isEmpty || sResult.isEmpty {
            log("Error: Show nuke report empty")
            return [:]
        }

        return parse_nuke_str(
            buildStr: bResult,
            statsStr: sResult
        )
    }
}

func parse_nuke_str(buildStr: [String], statsStr: [String])
    -> [String: NukeType]
{
    //    Printing for tech level '301'
    //                  lcm hcm  oil  rad avail tech res $
    //    10kt  fission  50  50   25   70    49  280   0 $ 10000
    //    15kt  fission  50  50   25   80    51  290   0 $ 15000
    //    50kt  fission  60  60   30   90    60  300   0 $ 25000
    var nukeTypes: [String: NukeType] = [:]

    for line in buildStr[2..<buildStr.count] {
        let bits = line.split(separator: " ")
        let abbrev = String(bits[0])
        var nuke = NukeType(abbrev: abbrev)
        nuke.name = "\(bits[0]) \(bits[1])"
        nuke.abbrev = String(bits[0])
        nuke.lcmCost = Int(bits[2])!
        nuke.hcmCost = Int(bits[3])!
        nuke.oilCost = Int(bits[4])!
        nuke.radCost = Int(bits[5])!
        nuke.avail = Int(bits[6])!
        nuke.tech = Int(bits[7])!
        nuke.research = Int(bits[8])!
        // $ is on a column of its own - consistency, not
        nuke.cost = Int(bits[10])!
        nukeTypes[abbrev] = nuke
    }

    //    Printing for tech level '301'
    //                  blst dam lbs tech res $        abilities
    //    10kt  fission    3  70   4  280   0 $  10000
    //    15kt  fission    3  90   5  290   0 $  15000
    //    50kt  fission    3 100   6  300   0 $  25000
    for line in statsStr[2..<statsStr.count] {
        let bits = line.split(separator: " ")
        let abbrev = String(bits[0])
        var nuke = nukeTypes[abbrev]!
        nuke.blast = Int(bits[2])!
        nuke.damage = Int(bits[3])!
        nuke.lbs = Int(bits[4])!
        if bits.count >= 9 {
            nuke.capabilities = bits[9...].joined(separator: " ")
        } else {
            nuke.capabilities = ""
        }
        nukeTypes[abbrev] = nuke
    }

    return nukeTypes
}
