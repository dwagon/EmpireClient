//
//  cd_show_plane.swift
//  EmpireClient
//
//  Created by Dougal Scott on 13/9/2026.
//

import Foundation

extension Game {
    /// Find out all the details of ships
    func cmd_show_plane() async {
        let bResult = await client.runCmd("show plane b")
        let sResult = await client.runCmd("show plane s")
        let cResult = await client.runCmd("show plane c")

        if bResult.isEmpty || sResult.isEmpty || cResult.isEmpty {
            log("Error: Show plane report empty")
            return
        }

        planeTypes = parse_plane_str(
            buildStr: bResult,
            statsStr: sResult,
            capStr: cResult
        )
    }
}

func parse_plane_str(buildStr: [String], statsStr: [String], capStr: [String])
    -> [String: PlaneType]
{
    //    Printing for tech level '104'
    //                              lcm hcm crew avail tech $
    //    f1   Sopwith Camel          8   2    1    32   50 $400
    //    lb   TBD-1 Devastator      10   3    1    36   60 $550
    //    as   anti-sub plane        10   3    2    36  100 $550
    var planeTypes: [String: PlaneType] = [:]

    for line in buildStr[2..<buildStr.count] {
        let bits = line.split(separator: " ")
        let abbrev = String(bits[0])
        let lastBit = bits.count
        let unitName = extractPlaneName(line)
        var plane = PlaneType(name: unitName)
        plane.abbrev = abbrev
        plane.lcmCost = Int(bits[lastBit - 6])!
        plane.hcmCost = Int(bits[lastBit - 5])!
        plane.crewCost = Int(bits[lastBit - 4])!
        plane.avail = Int(bits[lastBit - 3])!
        plane.tech = Int(bits[lastBit - 2])!
        plane.cost = Int(
            bits[lastBit - 1].replacingOccurrences(of: "$", with: "")
        )!
        planeTypes[abbrev] = plane
    }

    //    Printing for tech level '104'
    //                              acc load att def ran fuel stlth
    //    f1   Sopwith Camel         76    1   3   3   9    1    0%
    //    lb   TBD-1 Devastator      43    2   0   5  12    1    0%
    //    as   anti-sub plane        81    2   0   3  17    2    0%
    for line in statsStr[2..<statsStr.count] {
        let bits = line.split(separator: " ")
        let lastBit = bits.count
        var plane = planeTypes[String(bits[0])]!
        plane.acc = Int(bits[lastBit - 7])!
        plane.load = Int(bits[lastBit - 6])!
        plane.att = Int(bits[lastBit - 5])!
        plane.def = Int(bits[lastBit - 4])!
        plane.ran = Int(bits[lastBit - 3])!
        plane.fuel = Int(bits[lastBit - 2])!
        plane.stealth = Int(
            bits[lastBit - 1].replacingOccurrences(of: "%", with: "")
        )!
        planeTypes[String(bits[0])]! = plane
    }

    //    Printing for tech level '104'
    //                              capabilities
    //    f1   Sopwith Camel         tactical intercept VTOL
    //    lb   TBD-1 Devastator      bomber tactical VTOL light
    //    as   anti-sub plane        tactical ASW mine sweep
    for line in capStr[2..<capStr.count] {
        let pType = String(line.split(separator: " ")[0])

        var plane = planeTypes[pType]!
        let startIdx = String.Index(utf16Offset: 25, in: line)
        let newLine = line[startIdx...]
        plane.capabilities = String(newLine).trimmingCharacters(in: .whitespaces)
        planeTypes[pType] = plane
    }

    return planeTypes
}

private func extractPlaneName(_ line: String) -> String {
    let startIdx = String.Index(utf16Offset: 5, in: line)
    let endIdx = String.Index(utf16Offset: 25, in: line)
    let shipName: String = line[startIdx...endIdx].trimmingCharacters(
        in: .whitespaces
    )
    return shipName
}
