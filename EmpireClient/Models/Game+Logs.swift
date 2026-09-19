//
//  Game+Logs.swift
//  EmpireClient
//
//  Created by Dougal Scott on 19/9/2026.
//

import Foundation

enum LogType {
    case cmd
    case result
    case undefined
    case silent
}

struct Log: Identifiable {
    let id: UUID

    var type: LogType
    var entry: String

    init(type: LogType = .undefined, entry: String) {
        self.id = UUID()
        self.type = type
        self.entry = entry
    }

}

extension Game {
    func log(_ line: String, logType: LogType = .undefined) {
        if line.contains("\n") {
            for subline in line.split(separator: "\n") {
                logs.append(Log(type: logType, entry: String(subline)))
            }
        } else {
            logs.append(Log(type: logType, entry: line))
        }
    }

    func log(_ lines: [String], logType: LogType = .undefined) {
        for line in lines {
            log(line, logType: logType)
        }
    }
}
