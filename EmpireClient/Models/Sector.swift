//
//  Sector.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation

struct Sector {
    var coords: MapCoord
    var desig: Desig
    
    init(coords: MapCoord) {
        self.coords = coords
        desig = Desig.unknown
    }
}

enum Desig {
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
