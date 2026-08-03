//
//  Game.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation
import HexGrid

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
    
    func sector(coord: MapCoord) -> Cell?
    {
        return game_map.grid.cellAt(coord)
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

// MARK: -
struct MapCoord {
    let _coords: OffsetCoordinates
    init(x: Int, y: Int) {
        _coords = OffsetCoordinates(
            column: x,
            row: y,
            orientation: MapConfig.orientation,
            offsetLayout: MapConfig.offsetLayout
        )
    }
    
    var x: Int {
        return _coords.column
    }
    
    var y: Int {
        return _coords.row
    }
}
