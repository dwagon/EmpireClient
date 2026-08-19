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
    case iron_ore = "i"
    case gold_dust = "d"
    case gold_bars = "b"
    case oil = "o"
    case lcm = "l"
    case hcm = "h"
    case radioactives = "r"

    var name : String {
        switch self {
        case .none: return "none"
        case .civ: return "civilians"
        case .mil: return "military"
        case .uw: return "uncomp workers"
        case .food: return "food"
        case .shells: return "shells"
        case .guns: return "guns"
        case .planes: return "planes"
        case .iron_ore: return "iron ore"
        case .gold_dust: return "gold dust"
        case .gold_bars: return "gold bars"
        case .oil: return "oil"
        case .lcm: return "lcm"
        case .hcm: return "hcm"
        case .radioactives: return "radioactives"
        }
    }
}
