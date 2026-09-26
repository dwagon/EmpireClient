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
            if let tel = Telegram(result) {
                telegrams.append(tel)
            }
        }
    }
}
