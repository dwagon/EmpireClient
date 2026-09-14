//
//  cmd_plane.swift
//  EmpireClient
//
//  Created by Dougal Scott on 14/9/2026.
//  See https://www.empire.cx/infopages/plane.html

import Foundation

extension Game {
    func cmd_plane(planeNum: String = "*") async {
        let result = await client.runCmd("plane \(planeNum)")
        guard result != [] else {
            log("plane returned empty")
            return
        }
        parse_plane_cmd(result)
    }
    // #    type                x,y    w   eff  mu def tech ran hard carry special
    // 0 zep  Zeppelin          2,4       100%  60  -1  110  20    0
    // 1 plane
    func parse_plane_cmd(_ input: [String]) {
        let coordRegex = /(-*\d+),(-*\d+)/
        for line in input[1..<input.count - 1] {
            var plane: Plane
            let bits = line.split(separator: " ")
            let lastBit = bits.count
            let planeNum = String(bits[0])
            if planes[planeNum] == nil {
                plane = Plane(abbrev: String(bits[1]))
            } else {
                plane = planes[planeNum]!
            }
            plane.number = planeNum
            plane.harden = Int(bits[lastBit - 1])!
            plane.range = Int(bits[lastBit - 2])!
            plane.tech = Int(bits[lastBit - 3])!
            plane.def = Int(bits[lastBit - 4])!
            plane.mob = Int(bits[lastBit - 5])!
            plane.eff = Int(bits[lastBit - 6].replacingOccurrences(of: "%", with: ""))!
            if let match = line.firstMatch(of: coordRegex) {
                plane.coords = MapCoord(String(match.0))!
            }
            planes[planeNum] = plane
        }
    }
}
