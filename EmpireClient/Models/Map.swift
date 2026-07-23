//
//  Map.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation
import HexGrid

struct Map {
    var x_size: Int
    var y_size: Int
    var grid: HexGrid
    
    init(x_size: Int, y_size: Int) {
        self.x_size = x_size
        self.y_size = y_size
        self.grid = HexGrid(shape: GridShape.rectangle(x_size, y_size), orientation: .flatOnTop, offsetLayout: .even)
    }
}
