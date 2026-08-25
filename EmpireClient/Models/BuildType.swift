//
//  BuildType.swift
//  EmpireClient
//
//  Created by Dougal Scott on 25/8/2026.
//

import Foundation

enum BuildType: CaseIterable, Comparable {
    case ship
    case plane
    case land
    case nuke
    case bridge
    case nothing

    static func < (lhs: BuildType, rhs: BuildType) -> Bool {
        return lhs.abbrev < rhs.abbrev
    }

    var name: String {
        switch self {
        case .nothing: "Nothing"
        case .ship: "Ship"
        case .plane: "Plane"
        case .land: "Land Unit"
        case .bridge: "Bridge"
        case .nuke: "Nuke"
        }
    }

    var abbrev: String {
        switch self {
        case .ship: "s"
        case .plane: "p"
        case .land: "l"
        case .nuke: "n"
        case .bridge: "b"
        case .nothing: "x"
        }
    }
}
