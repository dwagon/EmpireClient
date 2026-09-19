//
//  cmd_navigate.swift
//  EmpireClient
//
//  Created by Dougal Scott on 1/9/2026.
//  See https://www.empire.cx/infopages/navigate.html

import Foundation

extension Game {

    func cmd_navigate(shipNum: String, destination: MapCoord) async {
        let nav_regex = /\<-?\d+.\d:-?\d+.\d: -?\d+,-?\d+\>/

        let result = await runCmd("navigate \(shipNum) \(destination.toString())")
        guard result != [] else {
            print("navigate returned empty")
            return
        }
        for line in result {
            if let _ = line.firstMatch(of: nav_regex) {
                _ = await runCmd("h")
            }
        }
    }
}
