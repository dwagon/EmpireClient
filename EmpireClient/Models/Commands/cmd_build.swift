//
//  cmd_build.swift
//  EmpireClient
//  https://www.empire.cx/infopages/build.html
//
//  Created by Dougal Scott on 23/8/2026.
//

import Foundation

enum BuildType: String {
    case ship = "s"
    case plane = "p"
    case land = "l"
    case nuke = "n"
    case bridge = "b"
    case tower = "t"
}

extension Game {
    // build [ship|plane|land|nuke] <SECTS> TYPE [NUMBER] [TECH] [SURE?]
    func cmd_build(
        device: BuildType,
        type: String,
        sector: MapCoord,
        number: Int = 1
    ) async {
        let cmd_string =
            "build \(device.rawValue) \(sector.toString()) \(number)"
        log(cmd_string)
        let result = await client.run_cmd(cmd_string)
        log(result)
    }

    /// Find out all the details of ships
    func cmd_show_ship() async {
        let b_result = await client.run_cmd("show ship b")
        let s_result = await client.run_cmd("show ship s")
        let c_result = await client.run_cmd("show ship c")

        if b_result.isEmpty || s_result.isEmpty || c_result.isEmpty {
            log("Error: Show ship report empty")
            return
        }

        shipTypes = parse_ship_str(
            buildStr: b_result,
            statsStr: s_result,
            capStr: c_result
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
        let bl = bits.count
        let shipName = extractShipname(line)
        var ship = ShipType(name: shipName)
        ship.abbrev = abbrev
        ship.lcm_cost = Int(bits[bl - 5])!
        ship.hcm_cost = Int(bits[bl - 4])!
        ship.avail = Int(bits[bl - 3])!
        ship.tech = Int(bits[bl - 2])!
        ship.cost = Int(bits[bl - 1].replacingOccurrences(of: "$", with: ""))!
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
        let bl = bits.count
        var ship = shipTypes[String(bits[0])]!
        ship.defence = Int(bits[bl - 10])!
        ship.speed = Int(bits[bl - 9])!
        ship.visible = Int(bits[bl - 8])!
        ship.spy = Int(bits[bl - 7])!
        ship.range = Int(bits[bl - 6])!
        ship.fire = Int(bits[bl - 5])!
        ship.landUnits = Int(bits[bl - 4])!
        ship.planes = Int(bits[bl - 3])!
        ship.helicopters = Int(bits[bl - 2])!
        ship.lightPlanes = Int(bits[bl - 1])!
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
        let start_idx = String.Index(utf16Offset: 25, in: line)
        let new_line = line[start_idx...]
        ship.cargo = String(new_line).trimmingCharacters(in: .whitespaces)
        shipTypes[stype] = ship
    }

    return shipTypes
}

private func extractShipname(_ line: String) -> String {
    let start_idx = String.Index(utf16Offset: 5, in: line)
    let end_idx = String.Index(utf16Offset: 26, in: line)
    let shipName: String = line[start_idx...end_idx].trimmingCharacters(
        in: .whitespaces
    )
    return shipName
}
