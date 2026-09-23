//
//  Nuke.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/9/2026.
//

import Foundation

typealias NukeNum = Int

struct NukeType: Identifiable, Codable, Buildable {
    var abbrev: String = ""
    var name: String = ""
    var lcmCost: Int = 0
    var hcmCost: Int = 0
    var oilCost: Int = 0
    var radCost: Int = 0
    var avail: Int = 0
    var tech: Int = 0
    var research: Int = 0
    var cost: Int = 0
    var blast: Int = 0
    var damage: Int = 0
    var lbs: Int = 0
    var capabilities: String = ""

    var id: String {
        return self.abbrev
    }
}
