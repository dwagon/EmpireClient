//
//  CargoCarrying.swift
//  EmpireClient
//
//  Created by Dougal Scott on 27/9/2026.
//

import Foundation

protocol CargoCarrying {
    var cargo: [Item:Int] {get set}
}

extension CargoCarrying {
    /// Represent the cargo as a string
    func cargoString() -> String {
        var ans: [String] = []
        for (type, val) in cargo {
            if val != 0 {
                ans.append("\(val)\(type.rawValue)")
            }
        }
        return ans.joined(separator: " ")
    }
}
