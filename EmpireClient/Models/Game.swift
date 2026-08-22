//
//  Game.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation

// MARK: -
@Observable
class Game {
    var game_map: Map
    var client = TCPClient()
    var nation_report: [String] = []
    var logs: [String] = []

    init() {
        game_map = Map(x_size: MapConfig.map_width, y_size: MapConfig.map_height)
    }

    subscript(key: MapCoord) -> Sector?
    {
        get {
            return game_map[key]
        }
        set {
            game_map[key] = newValue
        }
    }

    func log(_ line: String) {
        if line.contains("\n") {
            for subline in line.split(separator: "\n") {
                logs.append(String(subline))
            }
        }
        else {
            logs.append(line)
        }
    }

    func log(_ lines: [String]) {
        for line in lines {
            log(line)
        }
    }


    // MARK: -
    func login(country: String, password: String) async {
        var result = await client.run_cmd("coun \(country)")
        log(result)
        result = await client.run_cmd("pass \(password)")
        if result.contains("\"pass\" is not a legal command") {
            result = await client.run_cmd("break")
        }
        log(result)
        result = await client.run_cmd("play")
        log(result)

        await cmd_nation()
    }
}
