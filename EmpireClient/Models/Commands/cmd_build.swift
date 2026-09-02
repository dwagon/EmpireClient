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

    /// Find out all the details of ships
    func cmd_show_ship() async {
        let bResult = await client.runCmd("show ship b")
        let sResult = await client.runCmd("show ship s")
        let cResult = await client.runCmd("show ship c")

        if bResult.isEmpty || sResult.isEmpty || cResult.isEmpty {
            log("Error: Show ship report empty")
            return
        }

        shipTypes = parse_ship_str(
            buildStr: bResult,
            statsStr: sResult,
            capStr: cResult
        )
    }
}

func parse_ship_str(buildStr: [String], statsStr: [String], capStr: [String])
    -> [String: ShipType]
{
    // Printing for tech level '0'
    //                           lcm hcm avail tech $
    // fb   fishing boat          25  15    75    0 $180
    // ss   slave ship            60  40   160    0 $300
    // frg  frigate               30  30   110    0 $600
    var shipTypes: [String: ShipType] = [:]

    for line in buildStr[2..<buildStr.count] {
        let bits = line.split(separator: " ")
        let abbrev = String(bits[0])
        let lastBit = bits.count
        let shipName = extractShipname(line)
        var ship = ShipType(name: shipName)
        ship.abbrev = abbrev
        ship.lcmCost = Int(bits[lastBit - 5])!
        ship.hcmCost = Int(bits[lastBit - 4])!
        ship.avail = Int(bits[lastBit - 3])!
        ship.tech = Int(bits[lastBit - 2])!
        ship.cost = Int(bits[lastBit - 1].replacingOccurrences(of: "$", with: ""))!
        shipTypes[abbrev] = ship
    }

    // Printing for tech level '0'
    //                                s  v  s  r  f  l  p  h  x
    //                                p  i  p  n  i  n  l  e  p
    //                           def  d  s  y  g  r  d  n  l  l
    // fb   fishing boat          10 10 15  2  0  0  0  0  0  0
    // ss   slave ship            20 10 35  3  0  0  0  0  0  1
    // frg  frigate               50 25 25  3  1  1  2  0  0  1
    for line in statsStr[4..<statsStr.count] {
        let bits = line.split(separator: " ")
        let lastBit = bits.count
        var ship = shipTypes[String(bits[0])]!
        ship.defence = Int(bits[lastBit - 10])!
        ship.speed = Int(bits[lastBit - 9])!
        ship.visible = Int(bits[lastBit - 8])!
        ship.spy = Int(bits[lastBit - 7])!
        ship.range = Int(bits[lastBit - 6])!
        ship.fire = Int(bits[lastBit - 5])!
        ship.landUnits = Int(bits[lastBit - 4])!
        ship.planes = Int(bits[lastBit - 3])!
        ship.helicopters = Int(bits[lastBit - 2])!
        ship.lightPlanes = Int(bits[lastBit - 1])!
        shipTypes[String(bits[0])]! = ship
    }

    // Printing for tech level '0'
    //                           cargoes & capabilities
    // fb   fishing boat          300c 10m 900f 15u fish canal
    // ss   slave ship            20c 80m 200f 1200u
    // frg  frigate               60m 10s 2g 60f semi-land
    for line in capStr[2..<capStr.count] {
        let stype = String(line.split(separator: " ")[0])

        var ship = shipTypes[stype]!
        let startIdx = String.Index(utf16Offset: 25, in: line)
        let newLine = line[startIdx...]
        ship.cargo = String(newLine).trimmingCharacters(in: .whitespaces)
        shipTypes[stype] = ship
    }

    return shipTypes
}

private func extractShipname(_ line: String) -> String {
    let startIdx = String.Index(utf16Offset: 5, in: line)
    let endIdx = String.Index(utf16Offset: 26, in: line)
    let shipName: String = line[startIdx...endIdx].trimmingCharacters(
        in: .whitespaces
    )
    return shipName
}
