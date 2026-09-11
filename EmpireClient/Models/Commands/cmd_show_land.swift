//
//  cmd_show_land.swift
//  EmpireClient
//
//  Created by Dougal Scott on 11/9/2026.
//

import Foundation


extension Game {
    /// Find out all the details of ships
    func cmd_show_land() async {
        let bResult = await client.runCmd("show land b")
        let sResult = await client.runCmd("show land s")
        let cResult = await client.runCmd("show land c")

        if bResult.isEmpty || sResult.isEmpty || cResult.isEmpty {
            log("Error: Show land report empty")
            return
        }

        landTypes = parse_land_str(
            buildStr: bResult,
            statsStr: sResult,
            capStr: cResult
        )
    }
}

func parse_land_str(buildStr: [String], statsStr: [String], capStr: [String])
    -> [String: LandUnitType]
{
    //    Printing for tech level '44'
    //                              lcm hcm guns avail tech $
    //    cav  cavalry               10   5    0    40   30 $500
    //    art  artillery             20  10    0    60   35 $800
    //    linf light infantry         8   4    0    36   40 $300
    //    tra  train                100  50    0   220   40 $3500
    //    spy  infiltrator           10   5    0    40   40 $750
    var landTypes: [String: LandUnitType] = [:]

    for line in buildStr[2..<buildStr.count] {
        let bits = line.split(separator: " ")
        let abbrev = String(bits[0])
        let lastBit = bits.count
        let unitName = extractUnitName(line)
        var landUnit = LandUnitType(name: unitName)
        landUnit.abbrev = abbrev
        landUnit.lcmCost = Int(bits[lastBit - 6])!
        landUnit.hcmCost = Int(bits[lastBit - 5])!
        landUnit.gunCost = Int(bits[lastBit - 4])!
        landUnit.avail = Int(bits[lastBit - 3])!
        landUnit.tech = Int(bits[lastBit - 2])!
        landUnit.cost = Int(
            bits[lastBit - 1].replacingOccurrences(of: "$", with: "")
        )!
        landTypes[abbrev] = landUnit
    }

    //    Printing for tech level '44'
    //                                           s  v  s  r  r  a  f  a  a  x  l
    //                                           p  i  p  a  n  c  i  m  a  p  n
    //                              att def vul  d  s  y  d  g  c  r  m  f  l  d
    //    cav  cavalry              1.4 0.6  76 34 18  4  3  0  0  0  0  0  0  0
    //    art  artillery            0.1 0.4  67 19 20  1  0  8 48  5  2  1  0  0
    //    linf light infantry       1.1 1.6  58 29 15  2  1  0  0  0  1  1  0  0
    //    tra  train                0.0 0.0 117 10 25  3  0  0  0  0  0  0  5 12
    //    spy  infiltrator          0.0 0.0  78 33 18  4  3  0  0  0  0  0  0  0
    for line in statsStr[4..<statsStr.count] {
        let bits = line.split(separator: " ")
        let lastBit = bits.count
        var lunit = landTypes[String(bits[0])]!
        lunit.att = Float(bits[lastBit - 14])!
        lunit.def = Float(bits[lastBit - 13])!
        lunit.vulnerability = Int(bits[lastBit - 12])!
        lunit.speed = Int(bits[lastBit - 11])!
        lunit.visible = Int(bits[lastBit - 10])!
        lunit.spy = Int(bits[lastBit - 9])!
        lunit.reactionRadius = Int(bits[lastBit - 8])!
        lunit.range = Int(bits[lastBit - 7])!
        lunit.accuracy = Int(bits[lastBit - 6])!
        lunit.fire = Int(bits[lastBit - 5])!
        lunit.ammo = Int(bits[lastBit - 4])!
        lunit.aaf = Int(bits[lastBit - 3])!
        lunit.xpl = Int(bits[lastBit - 2])!
        lunit.lnd = Int(bits[lastBit - 1])!
        landTypes[String(bits[0])]! = lunit
    }

    //    Printing for tech level '44'
    //                              capabilities
    //    cav  cavalry               20m 12f light recon
    //    art  artillery             25m 40s 10g 24f light
    //    linf light infantry        25m 1s 15f light assault
    //    tra  train                 990m 990s 200g 990p 500i 500d 100b 990f 990o 990l 990h 150r supply train heavy
    //    spy  infiltrator           light recon assault spy
    for line in capStr[2..<capStr.count] {
        let lutype = String(line.split(separator: " ")[0])

        var lunit = landTypes[lutype]!
        let startIdx = String.Index(utf16Offset: 25, in: line)
        let newLine = line[startIdx...]
        lunit.capabilities = String(newLine).trimmingCharacters(in: .whitespaces)
        landTypes[lutype] = lunit
    }

    return landTypes
}

private func extractUnitName(_ line: String) -> String {
    let startIdx = String.Index(utf16Offset: 5, in: line)
    let endIdx = String.Index(utf16Offset: 25, in: line)
    let shipName: String = line[startIdx...endIdx].trimmingCharacters(
        in: .whitespaces
    )
    return shipName
}
