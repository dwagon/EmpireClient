//
//  cmd_read.swift
//  EmpireClient
//
//  Created by Dougal Scott on 26/9/2026.n
//  https://www.empire.cx/infopages/read.html

import Foundation

extension Game {
    func cmd_read(delete: String = "no") async {
        let result = await runCmd("read \(delete)", suppressLog: true)
        if !result.isEmpty {
            parse_cmd_read(result)
        }
    }

    func parse_cmd_read(_ input: [String]) {
        let regex = /^> (.*) dated (.*)/
        var batch: [String] = []
        for line in input {
            if line.firstMatch(of: regex) != nil && !batch.isEmpty && batch != [""] {
                if let tel = Telegram(batch) {
                    telegrams.append(tel)
                }
                batch = []
            }
            batch.append(line)
        }
        if let tel = Telegram(batch) {
            telegrams.append(tel)
        }
    }
}
