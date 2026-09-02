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
        let cmdString = "navigate \(shipNum) \(destination.toString())"
        log(cmdString)
        let result = await client.runCmd(cmdString)
        log("navigate=\(result)")
        guard result != [] else {
            print("navigate returned empty")
            return
        }
        print("navigate: \(result)")
        for line in result {
            if let _ = line.firstMatch(of: nav_regex) {
                _ = await client.runCmd("h")
            }
        }
    }
}
