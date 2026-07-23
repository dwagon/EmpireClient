//
//  Game.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation

// MARK: -
class Game {
    private var _map: Map
    var coord: MapCoord

    init() {
        _map = Map(x_size: 64, y_size: 64)
        coord = MapCoord(x: 0, y: 0)
    }
    
    var game_map: Map {
        get { return _map }
    }
}

// MARK: -
struct MapCoord {
    var x: Int
    var y: Int
}
