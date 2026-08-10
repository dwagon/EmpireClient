//
//  Sector.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation

class Sector {
    var coords: MapCoord
    var desig: Desig
    var sdes: Desig
    var data: [MapKey: MapKeyValue] = [:]

    init(coords: MapCoord) {
        self.coords = coords
        desig = Desig("?")
        sdes = Desig("?")
    }

    subscript(index: MapKey) -> MapKeyValue? {
        get {
            return data[index]
        }
        set {
            // print("\(coords) set \(index) to \(newValue, default: "nil")")
            data[index] = newValue
        }
    }

    var symbol: String {
        return desig.abbrev
    }

    var description: String {
        return desig.name
    }
}
