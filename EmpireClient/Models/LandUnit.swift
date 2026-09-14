//
//  LandUnit.swift
//  EmpireClient
//
//  Created by Dougal Scott on 11/9/2026.
//

import Foundation

struct LandType: Identifiable, Codable {
    var abbrev: String = ""
    var name: String = ""
    var lcmCost: Int = 0
    var hcmCost: Int = 0
    var gunCost: Int = 0
    var avail: Int = 0
    var tech: Int = 0
    var cost: Int = 0
    var att: Float = 0.0
    var def: Float = 0.0
    var vulnerability: Int = 0
    var speed: Int = 0
    var visible: Int = 0
    var spy: Int = 0
    var reactionRadius: Int = 0
    var range: Int = 0
    var accuracy: Int = 0
    var fire: Int = 0
    var ammo: Int = 0
    var aaf: Int = 0
    var xpl: Int = 0
    var lnd: Int = 0
    var capabilities: String = ""

    var id: String {
        return self.abbrev
    }
}

struct LandUnit: Identifiable, Codable {
    var number: String = ""
    var abbrev: String = ""
    var coords: MapCoord = MapCoord(x: 0, y: 0)
    var army: String = ""
    var eff: Int = 0
    var fortification: Int = 0
    var mob: Int = 0
    var tech: Int = 0
    var retreat: Int = 0
    var react: Int = 0
    var xl: Int = 0
    var nland: Int = 0
    var land: String = ""
    var ship: String = ""
    var cargo: [Item: Int] = [:]
    var attack: Float = 0
    var defense: Float = 0
    var vulnerability: Int = 0
    var speed: Int = 0
    var visibility: Int = 0
    var spy: Int = 0
    var radius: Int = 0
    var frg: Int = 0
    var accuracy: Int = 0
    var damage: Int = 0
    var ammoUse: Int = 0
    var aaf: Int = 0

    var id: String {
        return String(self.number)
    }
}
