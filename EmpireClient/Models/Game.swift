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

    // MARK: -
    func login(country: String, password: String) async {
        var result = await client.run_cmd("coun \(country)")
        print("coun = '\(result)'")
        result = await client.run_cmd("pass \(password)")
        print("pass = '\(result)'")
        result = await client.run_cmd("play")
        print("play = '\(result)'")
    }
}
