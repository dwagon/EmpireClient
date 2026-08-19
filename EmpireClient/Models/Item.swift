//
//  Item.swift
//  EmpireClient
//
//  Created by Dougal Scott on 14/8/2026.
//

import Foundation

enum Item: String, CaseIterable {
    case none = ""  // For init purposes
    case civ = "c"
    case mil = "m"
    case uw = "u"
    case food = "f"
    case shells = "s"
    case guns = "g"
    case planes = "p"
    case ironOre = "i"
    case goldDust = "d"
    case goldBars = "b"
    case oil = "o"
    case lcm = "l"
    case hcm = "h"
    case radioactives = "r"

    var displayName: String {
        switch self {
        case .none: "none"
        case .civ: "civilians"
        case .mil: "military"
        case .uw: "uncomp workers"
        case .food: "food"
        case .shells: "shells"
        case .guns: "guns"
        case .planes: "planes"
        case .ironOre: "iron ore"
        case .goldDust: "gold dust"
        case .goldBars: "gold bars"
        case .oil: "oil"
        case .lcm: "lcm"
        case .hcm: "hcm"
        case .radioactives: "radioactives"
        }
    }
}
