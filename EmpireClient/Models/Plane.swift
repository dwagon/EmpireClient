//
//  Plane.swift
//  EmpireClient
//
//  Created by Dougal Scott on 13/9/2026.
//

import Foundation

struct PlaneType: Identifiable, Codable {
    var abbrev: String = ""
    var name: String = ""
    var lcmCost: Int = 0
    var hcmCost: Int = 0
    var crewCost: Int = 0
    var avail: Int = 0
    var tech: Int = 0
    var cost: Int = 0
    var acc: Int = 0
    var load: Int = 0
    var att: Int = 0
    var def: Int = 0
    var ran: Int = 0
    var fuel: Int = 0
    var stealth: Int = 0
    var capabilities: String = ""

    var id: String {
        return self.abbrev
    }
}

struct Plane: Identifiable, Codable {
    var number: String = ""
    var abbrev: String = ""
    var coords: MapCoord = MapCoord(x: 0, y: 0)
    var wing: String = ""
    var mob: Int = 0
    var eff: Int = 0
    var attack: Int = 0
    var defence: Int = 0
    var accuracy: Int = 0
    var tech: Int = 0
    var range: Int = 0
    var react: Int = 0
    var load: Int = 0
    var harden: Int = 0
    var fuel: Int = 0
    var ship: String = ""
    var land: String = ""
    var launched: String = ""
    var orbit: String = ""
    var nuke: String = ""
    var groundburst: String = ""

    var id: String {
        return String(self.number)
    }
}
