//
//  Desig.swift
//  EmpireClient
//
//  Created by Dougal Scott on 5/8/2026.
//

import Foundation


enum Desig: String {
    init(_ rawValue: String) {
        switch rawValue {
        case "c":
            self = .capital
        case "_":
            self = .unknown
        default:
            print("Unhandled Desig init value \(rawValue)")
            self = .unknown
        }
    }

    var description : String {
        return self.rawValue.capitalized
    }

    case sea = "Sea"
    case mountain = "Mountain"
    case sanctuary = "Sanctuary"
    case wasteland = "Wasteland"
    case wilderness = "Wilderness"
    case plains = "Plains"
    case capital = "Capital"
    case park = "Park"
    case highway = "Highway"
    case radar = "Radar"
    case bridge_head = "Bridge Head"
    case bridge_span = "Bridge Span"
    case bridge_tower = "Bridge Tower"
    case defense_plant = "Defense Plant"
    case shell_industry = "Shell Industry"
    case mine = "Mine"
    case gold_mine = "Gold Mine"
    case harbor = "Harbor"
    case warehouse = "Warehouse"
    case uranium_mine = "Uranium Mine"
    case airfield = "Airfield"
    case agribusiness = "Agribusiness"
    case oil_field = "Oil Field"
    case light_manufacturing = "Light manufacturing"
    case heavy_manufacturing = "Heavy manufacturing"
    case refinery = "Refinery"
    case technical_center = "Technical Center"
    case fortress = "Fortress"
    case research_lab = "Research Lab"
    case nuclear_plant = "Nuclear Plant"
    case library = "Library"
    case enlistment_center = "Enlistment Center"
    case headquarters = "Headquarters"
    case bank = "Bank"
    case unknown = "Unknown"
    }
