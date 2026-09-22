//
//  Buildable.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/9/2026.
//

import Foundation

protocol Buildable {
    var tech: Int {get set}
}

extension Buildable {
    func isBuildable(techlevel: Float) -> Bool {
        return Float(self.tech) <= techlevel
    }
}

