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

enum DesigType: CaseIterable, Comparable, Codable {
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
    case bridgeHead
    case bridgeSpan
    case bridgeTower
    case defensePlant
    case shellIndustry
    case mine
    case goldMine
    case harbor
    case warehouse
    case uraniumMine
    case airfield
    case agribusiness
    case oilField
    case lightManufacturing
    case heavyManufacturing
    case refinery
    case technicalCenter
    case fortress
    case researchLab
    case nuclearPlant
    case library
    case enlistmentCenter
    case headquarters
    case bank
    case unknown

    static func < (lhs: DesigType, rhs: DesigType) -> Bool {
        let lDesType = Desig(lhs)
        let rDesType = Desig(rhs)
        return lDesType.name < rDesType.name
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
    .bridgeHead: [.name: "Bridge Head", .abbrev: "#"],
    .bridgeSpan: [.name: "Bridge Span", .abbrev: "="],
    .bridgeTower: [.name: "Bridge Tower", .abbrev: "@"],
    .defensePlant: [.name: "Defense Plant", .abbrev: "d"],
    .shellIndustry: [.name: "Shell Industry", .abbrev: "i"],
    .mine: [.name: "Mine", .abbrev: "m"],
    .goldMine: [.name: "Gold Mine", .abbrev: "g"],
    .harbor: [.name: "Harbor", .abbrev: "h"],
    .warehouse: [.name: "Warehouse", .abbrev: "w"],
    .uraniumMine: [.name: "Uranium Mine", .abbrev: "u"],
    .airfield: [.name: "Airfield", .abbrev: "*"],
    .agribusiness: [.name: "Agribusiness", .abbrev: "a"],
    .oilField: [.name: "Oil Field", .abbrev: "o"],
    .lightManufacturing: [.name: "Light manufacturing", .abbrev: "j"],
    .heavyManufacturing: [.name: "Heavy manufacturing", .abbrev: "k"],
    .refinery: [.name: "Refinery", .abbrev: "%"],
    .technicalCenter: [.name: "Technical Center", .abbrev: "t"],
    .fortress: [.name: "Fortress", .abbrev: "f"],
    .researchLab: [.name: "Research Lab", .abbrev: "r"],
    .nuclearPlant: [.name: "Nuclear Plant", .abbrev: "n"],
    .library: [.name: "Library", .abbrev: "l"],
    .enlistmentCenter: [.name: "Enlistment Center", .abbrev: "e"],
    .headquarters: [.name: "Headquarters", .abbrev: "!"],
    .bank: [.name: "Bank", .abbrev: "b"],
    .unknown: [.name: "Unknown", .abbrev: "_"]
]

/// Players can't designate sectors of these types
var undesignatable: Set<DesigType> = [
    .sea, .mountain, .sanctuary, .wasteland, .wilderness, .plains, .unknown
]

struct Desig: Equatable {
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
