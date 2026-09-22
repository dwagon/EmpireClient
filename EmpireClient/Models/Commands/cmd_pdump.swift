//
//  cmd_pdump.swift
//  EmpireClient
//
//  Created by Dougal Scott on 14/9/2026.
//  See https://www.empire.cx/infopages/pdump.html

import Foundation

extension Game {
    func cmd_pdump(str: String = "*") async {
        let result = await runCmd("pdump \(str)", suppressLog: true)
        parse_cmd_pdump(result)
    }

    func cmd_pdump(plane: Plane) async {
        let result = await runCmd("pdump \(plane.number)")
        parse_cmd_pdump(result)
    }

    //    Mon Sep 14 11:49:53 2026
    //    DUMP PLANES 1789350593
    //    id type x y wing eff mob tech att def acc react range load fuel hard ship land laun orb nuke grd
    //    0 zep  2 4 ~ 100 60 110 0 -1 52 20 20 2 3 4 -1 -1 N N N/A G
    //    1 plane
    func parse_cmd_pdump(_ input: [String]) {
        var plane: Plane
        var exists: Set<PlaneNum> = []

        for line in input[3..<input.count - 1] {
            let bits = line.split(separator: " ")
            let planeNum = PlaneNum(bits[0])!
            if planes[planeNum] == nil {
                plane = Plane(abbrev: String(bits[1]))
            } else {
                plane = planes[planeNum]!
            }
            plane.number = planeNum
            plane.abbrev = String(bits[1])
            plane.coords = MapCoord(x: Int(bits[2])!, y: Int(bits[3])!)
            plane.wing = String(bits[4])
            plane.eff = Int(bits[5])!
            plane.mob = Int(bits[6])!
            plane.tech = Int(bits[7])!
            plane.attack = Int(bits[8])!
            plane.defence = Int(bits[9])!
            plane.accuracy = Int(bits[10])!
            plane.react = Int(bits[11])!
            plane.range = Int(bits[12])!
            plane.load = Int(bits[13])!
            plane.fuel = Int(bits[14])!
            plane.harden = Int(bits[15])!
            plane.ship = ShipNum(bits[16])!
            plane.land = String(bits[17])
            plane.launched = String(bits[18])
            plane.orbit = String(bits[19])
            plane.nuke = String(bits[20])
            plane.groundburst = String(bits[21])
            planes[planeNum] = plane
            exists.insert(planeNum)
        }

        // Remove ships that weren't in the dump
        for planeNum in planes.keys {
            if !exists.contains(planeNum) {
                planes.removeValue(forKey: planeNum)
            }
        }
    }
}
