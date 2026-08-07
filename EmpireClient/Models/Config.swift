//
//  Config.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/7/2026.
//

import Foundation
import HexGrid

// MARK: -
/// Config for hex grid map
struct MapConfig {
    static let orientation = Orientation.pointyOnTop
    static let offsetLayout = OffsetLayout.odd
    static let map_width = 32
    static let map_height = 64
    static let cellSize: Double = 20
    static let hexSize = HexSize(width: cellSize, height: cellSize)
    static let mapRadius = 4
}
