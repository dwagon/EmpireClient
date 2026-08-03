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

    init(x_size: Int = 64, y_size: Int = 32) {
        self.x_size = x_size
        self.y_size = y_size
        self.grid = HexGrid(
            shape: GridShape.rectangle(x_size, y_size),
            orientation: MapConfig.orientation,
            offsetLayout: MapConfig.offsetLayout,
            hexSize: HexSize(
                width: MapConfig.cellSize,
                height: MapConfig.cellSize
            ),
        )
    }

    func set_attr(
        _ coordinates: OffsetCoordinates,
        key: String,
        newValue: Attribute
    ) {
        if let cell = grid.cellAt(coordinates) {
            cell.attributes[key] = newValue
        }
    }

    func set_attr(_ coordinates: MapCoord, key: String, newValue: Attribute)
        throws
    {
        if let cell = try grid.cellAt(coordinates._coords.toCube()) {
            cell.attributes[key] = newValue
        }
    }
    
    func cellAt(_ coordinates: MapCoord) -> Cell? {
        return grid.cellAt(coordinates)
    }
}

extension HexGrid {
    func cellAt(_ coordinates: OffsetCoordinates) -> Cell? {
        guard let cube_coords = try? coordinates.toCube() else { return nil }
        return self.cells.first(where: { $0.coordinates == cube_coords })

    }

    func cellAt(_ coordinates: MapCoord) -> Cell? {
        guard let cube_coords = try? coordinates._coords.toCube() else {
            return nil
        }
        return self.cells.first(where: { $0.coordinates == cube_coords })
    }
}


