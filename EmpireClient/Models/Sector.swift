//
//  Sector.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation

class Sector: Identifiable, Hashable {
    var coords: MapCoord
    var desig: Desig
    var sdes: Desig
    var owned: Bool = false
    var data: [MapKey: MapKeyValue] = [:]

    init(coords: MapCoord) {
        self.coords = coords
        desig = Desig("?")
        sdes = Desig("?")
    }

    static func == (lhs: Sector, rhs: Sector) -> Bool {
        return lhs.coords == rhs.coords
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(coords)
    }

    var description: String {
        return "<Sector \(coords.x), \(coords.y): \(desig.name)>"
    }

    subscript(index: MapKey) -> MapKeyValue? {
        get {
            return data[index]
        }
        set {
            data[index] = newValue
        }
    }

    var symbol: String {
        return desig.abbrev
    }
}
