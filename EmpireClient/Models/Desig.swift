//
//  Desig.swift
//  EmpireClient
//
//  Created by Dougal Scott on 5/8/2026.
//  See https://www.empire.cx/infopages/Sector-types.html
//

import Foundation

enum DesigKey {
    case name
    case abbrev
}

enum DesigType: CaseIterable, Comparable {
    case sea
    case mountain
    case sanctuary
    case wasteland
    case wilderness
    case plains
    case capital
    case park
    case highway
    case radar
    case bridge_head
    case bridge_span
    case bridge_tower
    case defense_plant
    case shell_industry
    case mine
    case gold_mine
    case harbor
    case warehouse
    case uranium_mine
    case airfield
    case agribusiness
    case oil_field
    case light_manufacturing
    case heavy_manufacturing
    case refinery
    case technical_center
    case fortress
    case research_lab
    case nuclear_plant
    case library
    case enlistment_center
    case headquarters
    case bank
    case unknown

    static func < (lhs: DesigType, rhs: DesigType) -> Bool {
        let l = Desig(lhs)
        let r = Desig(rhs)
        return l.name < r.name
    }
}

let desigDetails: [DesigType: [DesigKey: String]] = [
    .sea: [.name: "Sea", .abbrev: "."],
    .mountain: [.name: "Mountain", .abbrev: "^"],
    .sanctuary: [.name: "Sanctuary", .abbrev: "s"],
    .wasteland: [.name: "Wasteland", .abbrev: "\\"],
    .wilderness: [.name: "Wilderness", .abbrev: "-"],
    .plains: [.name: "Plains", .abbrev: "~"],
    .capital: [.name: "Capital", .abbrev: "c"],
    .park: [.name: "Park", .abbrev: "p"],
    .highway: [.name: "Highway", .abbrev: "+"],
    .radar: [.name: "Radar", .abbrev: ")"],
    .bridge_head: [.name: "Bridge Head", .abbrev: "#"],
    .bridge_span: [.name: "Bridge Span", .abbrev: "="],
    .bridge_tower: [.name: "Bridge Tower", .abbrev: "@"],
    .defense_plant: [.name: "Defense Plant", .abbrev: "d"],
    .shell_industry: [.name: "Shell Industry", .abbrev: "i"],
    .mine: [.name: "Mine", .abbrev: "m"],
    .gold_mine: [.name: "Gold Mine", .abbrev: "g"],
    .harbor: [.name: "Harbor", .abbrev: "h"],
    .warehouse: [.name: "Warehouse", .abbrev: "w"],
    .uranium_mine: [.name: "Uranium Mine", .abbrev: "u"],
    .airfield: [.name: "Airfield", .abbrev: "*"],
    .agribusiness: [.name: "Agribusiness", .abbrev: "a"],
    .oil_field: [.name: "Oil Field", .abbrev: "o"],
    .light_manufacturing: [.name: "Light manufacturing", .abbrev: "j"],
    .heavy_manufacturing: [.name: "Heavy manufacturing", .abbrev: "k"],
    .refinery: [.name: "Refinery", .abbrev: "%"],
    .technical_center: [.name: "Technical Center", .abbrev: "t"],
    .fortress: [.name: "Fortress", .abbrev: "f"],
    .research_lab: [.name: "Research Lab", .abbrev: "r"],
    .nuclear_plant: [.name: "Nuclear Plant", .abbrev: "n"],
    .library: [.name: "Library", .abbrev: "l"],
    .enlistment_center: [.name: "Enlistment Center", .abbrev: "e"],
    .headquarters: [.name: "Headquarters", .abbrev: "!"],
    .bank: [.name: "Bank", .abbrev: "b"],
    .unknown: [.name: "Unknown", .abbrev: "_"],
]

/// Players can't designate sectors of these types
var undesignatable: Set<DesigType> = [.sea, .mountain, .sanctuary, .wasteland, .wilderness, .plains, .unknown ]

struct Desig {
    var desig: DesigType

    init(_ char: String) {
        if char == "?" {
            self.desig = .unknown
        } else {
            self.desig =
                desigDetails.first { item in
                    item.value[.abbrev] == char
                }?.key ?? .unknown
        }
    }

    init(_ des: DesigType) {
        self.desig = des
    }

    var abbrev: String {
        if let details = desigDetails[desig] {
            if let abbrev = details[.abbrev] {
                return abbrev
            }

        }
        print("Error: no abbrev for \(desig)")
        return "?"
    }

    var isDesignatable: Bool {
            if undesignatable.contains(desig) {
                return false
        }
        return true
    }

    var name: String {
        if let details = desigDetails[desig] {
            if let name = details[.name] {
                return name
            }

        }
        print("Error: no name for \(desig)")
        return "unknown"
    }
}
