//
//  cmd_ndump.swift
//  EmpireClient
//
//  Created by Dougal Scott on 26/9/2026.
//  See https://www.empire.cx/infopages/ndump.html

import Foundation

extension Game {
    func cmd_ndump(_ arg: String = "*") async {
        let result = await runCmd("ndump \(arg)", suppressLog: true)
        guard result != [] else {
            log("ndump returned empty")
            return
        }
        parse_cmd_ndump(result, trimMissing: true)
    }

    func cmd_ndump(nuke: NukeNum) async {
        let result = await runCmd("ndump \(nuke)", suppressLog: true)
        guard result != [] else {
            log("ndump returned empty")
            return
        }
        parse_cmd_ndump(result, trimMissing: false)
    }

    // Sat Sep 26 10:25:27 2026
    // DUMP NUKES 1790382327
    // id x y num type
    // 0 15 -1 1 10kt
    // 1 nuke
    func parse_cmd_ndump(_ input: [String], trimMissing: Bool = true) {
        var nuke: Nuke
        var exists: Set<NukeNum> = []

        for line in input {
            let bits = line.split(separator: " ")
            if bits[0] == "id" || bits[0] == "DUMP" {   // Headers
                continue
            }
            if bits[1].starts(with: "nuke") {   // footer
                break
            }
            if Int(bits[0]) == nil {
                continue
            }
            let nukeNum = NukeNum(bits[0])!
            if nukes[nukeNum] == nil {
                nuke = Nuke()
            }
            else {
                nuke = nukes[nukeNum]!
            }
            nuke.number = nukeNum
            nuke.coords = MapCoord(x: Int(bits[1])!, y: Int(bits[2])!)
            nuke.abbrev = String(bits[4])
            nukes[nukeNum] = nuke
            exists.insert(nukeNum)

            // Remove planes that weren't in the dump
            for nukeNum in nukes.keys {
                if !exists.contains(nukeNum) && trimMissing {
                    planes.removeValue(forKey: nukeNum)
                }
            }
        }
    }
}
