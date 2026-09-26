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
            input.remove(at:0)
        }
        if let match = try? regex.firstMatch(in: input[0]) {
            from = String(match.1)
            date = String(match.2)
            content = Array(input.dropFirst())
        }
        else {
            return nil
        }
    }

    var id: String {
        return "\(from) \(date)"
    }
}
