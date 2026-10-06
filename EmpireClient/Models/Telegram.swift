//
//  Telegram.swift
//  EmpireClient
//
//  Created by Dougal Scott on 26/9/2026.
//

import Foundation

// > Telegram from POGO, (#0)  dated Sat Sep 26 18:34:46 2026
// Hiya

class Telegram: Identifiable {
    var date: String
    var from: String
    var content: [String]

    init?(_ rawInput: [String]) {
        let regex = /> (.*) dated (.*)/
        guard !rawInput.isEmpty else {
            return nil
        }
        var input = rawInput
        if input[0] == "" {
            input.remove(at: 0)
        }
        if let match = try? regex.firstMatch(in: input[0]) {
            from = String(match.1)
            date = String(match.2)
            content = Array(input.dropFirst())
        } else {
            return nil
        }
    }

    /// Extract all problem locations for highlighting
    func getProblems() -> [MapCoord: [String]] {
        // iron ore production backlog in -16,6
        var ans: [MapCoord: [String]] = [:]
        let problemRegexes = [
            /(.* production backlog) in (-?\d+,-?\d+)/,
            /(Guerrilla warfare) in (-?\d+,-?\d+)/,
            /(Partisans take over) (-?\d+,-?\d+)!/,
            /(Production .* disrupted by terrorists) in (-?\d+,-?\d+)/,
        ]

        for line in content {
            for reg in problemRegexes {
                if let match = try? reg.firstMatch(in: line),
                    let coord = MapCoord(String(match.2))
                {
                    ans[coord, default: []].append(String(match.1))
                }
            }
        }
        return ans
    }

    var id: String {
        return "\(from) \(date)"
    }
}
