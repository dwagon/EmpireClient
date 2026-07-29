//
//  Game.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation
import HexGrid

// MARK: -
class Game {
    private var _map: Map
    var coord: MapCoord  // Coord we are focussing on
    var client = TCPClient()
    var loggedIn: Bool = false

    init() {
        _map = Map(x_size: 64, y_size: 64)
        coord = MapCoord(x: 0, y: 0)
    }

    var game_map: Map {
        return _map
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
            orientation: .flatOnTop,
            offsetLayout: .even
        )
    }
    
    var x: Int {
        return _coords.column
    }
    
    var y: Int {
        return _coords.row
    }
}
