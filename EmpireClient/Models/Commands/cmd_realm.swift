//
//  cmd_realm.swift
//  EmpireClient
//
//  Created by Dougal Scott on 25/9/2026.
//  See https://www.empire.cx/infopages/realm.html

import Foundation

extension Game {
    func cmd_realm() async {
        let result = await runCmd("realm", suppressLog: true)
        parse_cmd_realm(result)
    }

    func cmd_realm(number: Int, sects: String) async {
        let _ = await runCmd("realm \(number) \(sects)")
    }

    // Realm #0 is -8:10,-5:5
    // Realm #1 is 10:24,-2:4
    func parse_cmd_realm(_ input: [String]) {
        var matched: Set<String> = []
        let regex = /Realm #(\d+) is (.*)/
        for line in input {
            if let match = line.firstMatch(of: regex) {
                let realm = String(match.2)
                if matched.contains(realm) {    // Avoid duplicate realms
                    continue
                }
                realms[Int(match.1)!] = Realm(realm)
                matched.insert(realm)
            }
        }
    }
}
