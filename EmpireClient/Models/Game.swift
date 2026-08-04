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
    var coord: MapCoord  // Coord we are focussing on
    var client = TCPClient()
    var loggedIn: Bool = false

    init() {
        game_map = Map(x_size: MapConfig.map_width, y_size: MapConfig.map_height)
        coord = MapCoord(x: 6, y: 0)
    }
    
    func sector(_ coord: MapCoord) -> Sector?
    {
        return game_map.map_data[coord]
    }

    // MARK: -
    func login(country: String, password: String) async {
        var result = await client.run_cmd("coun \(country)")
        print("coun = '\(result)'")
        result = await client.run_cmd("pass \(password)")
        loggedIn=true
        print("pass = '\(result)'")
        result = await client.run_cmd("play")
        print("play = '\(result)'")
        await cmd_dump()
    }
}
