//
//  Ship.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/8/2026.
//  See https://www.empire.cx/infopages/Ships.html

import Foundation

struct ShipType: Identifiable {

    var abbrev: String = ""
    var name: String = ""
    var lcm_cost: Int = 0
    var hcm_cost: Int = 0
    var avail: Int = 0
    var tech: Int = 0
    var cost: Int = 0
    var defence: Int = 0
    var speed: Int = 0
    var visible: Int = 0    // How easy it is for the ship to be seen
    var spy: Int = 0 // How easy it is for the ship to see
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

struct Ship {
    var number: Int = 0
    var type: ShipType
}
