//
//  Ship.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/8/2026.
//  See https://www.empire.cx/infopages/Ships.html

import Foundation

struct ShipType: Identifiable, Codable {
    var abbrev: String = ""
    var name: String = ""
    var lcmCost: Int = 0
    var hcmCost: Int = 0
    var avail: Int = 0
    var tech: Int = 0
    var cost: Int = 0
    var defence: Int = 0
    var speed: Int = 0
    var visible: Int = 0  // How easy it is for the ship to be seen
    var spy: Int = 0  // How easy it is for the ship to see
    var range: Int = 0
    var fire: Int = 0
    var landUnits: Int = 0
    var planes: Int = 0
    var helicopters: Int = 0
    var lightPlanes: Int = 0
    var cargo: String = ""

    var id: String {
        return self.abbrev
    }
}

struct Ship: Identifiable, Codable {
    var number: String = ""
    var type: String = ""
    var coords: MapCoord = MapCoord(x: 0, y: 0)
    var fleet: String = ""
    var eff: Int = 0
    var civ: Int = 0
    var mil: Int = 0
    var uw: Int = 0
    var food: Int = 0
    var planes: Int = 0
    var heli: Int = 0
    var xlPlanes: Int = 0
    var landUnits: Int = 0
    var mob: Int = 0
    var tech: Int = 0

    var id: String {
        return String(self.number)
    }
}
