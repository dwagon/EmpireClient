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

enum DesigType {
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
    .bridge_head: [.name: "Bridge Head", .abbrev: "Q"],
    .bridge_span: [.name: "Bridge Span", .abbrev: "Q"],
    .bridge_tower: [.name: "Bridge Tower", .abbrev: "Q"],
    .defense_plant: [.name: "Defense Plant", .abbrev: "Q"],
    .shell_industry: [.name: "Shell Industry", .abbrev: "Q"],
    .mine: [.name: "Mine", .abbrev: "Q"],
    .gold_mine: [.name: "Gold Mine", .abbrev: "Q"],
    .harbor: [.name: "Harbor", .abbrev: "Q"],
    .warehouse: [.name: "Warehouse", .abbrev: "Q"],
    .uranium_mine: [.name: "Uranium Mine", .abbrev: "Q"],
    .airfield: [.name: "Airfield", .abbrev: "Q"],
    .agribusiness: [.name: "Agribusiness", .abbrev: "Q"],
    .oil_field: [.name: "Oil Field", .abbrev: "Q"],
    .light_manufacturing: [.name: "Light manufacturing", .abbrev: "Q"],
    .heavy_manufacturing: [.name: "Heavy manufacturing", .abbrev: "Q"],
    .refinery: [.name: "Refinery", .abbrev: "Q"],
    .technical_center: [.name: "Technical Center", .abbrev: "Q"],
    .fortress: [.name: "Fortress", .abbrev: "Q"],
    .research_lab: [.name: "Research Lab", .abbrev: "Q"],
    .nuclear_plant: [.name: "Nuclear Plant", .abbrev: "Q"],
    .library: [.name: "Library", .abbrev: "Q"],
    .enlistment_center: [.name: "Enlistment Center", .abbrev: "Q"],
    .headquarters: [.name: "Headquarters", .abbrev: "Q"],
    .bank: [.name: "Bank", .abbrev: "Q"],
    .unknown: [.name: "Unknown", .abbrev: "_"],
]

struct Desig {
    var desig: DesigType

    init(_ char: String) {
        if char == "?" {
            self.desig = .unknown
        }
        else {
            
            self.desig =
            desigDetails.first { item in
                item.value[.abbrev] == char
            }?.key ?? .unknown
        }
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
