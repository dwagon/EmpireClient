//
//  MapView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import HexGrid
import SwiftUI

enum ResourceMapStyle {
    case normal
    case fertility
    case gold
    case mine
    case oil
    case uranium
}

enum UnitMapStyle {
    case none
    case ship
    case plane
    case land
}

struct MapView: View {
    let game_map: Map
    @Binding var center_coord: MapCoord
    let ships: [Int: Ship]

    @State var displayResourceMapStyle: ResourceMapStyle = .normal
    @State var displayUnitMapStyle: UnitMapStyle = .none

    var hexmap = HexGrid(
        shape: .hexagon(MapConfig.mapRadius),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize
    )

    var body: some View {
        VStack {
            DrawHex(
                hexmap: hexmap,
                cellText: cellText,
                cellFillColour: cellColour,
                cellEdgeColour: edgeColour,
                hexGesture: hexGesture
            )
            Picker("", selection: $displayUnitMapStyle) {
                Text("Normal").tag(UnitMapStyle.none)
                Text("Ship").tag(UnitMapStyle.ship)
                Text("Plane").tag(UnitMapStyle.plane)
                Text("Land Unit").tag(UnitMapStyle.land)
            }.pickerStyle(.segmented)
            Picker("", selection: $displayResourceMapStyle) {
                Text("Normal").tag(ResourceMapStyle.normal)
                Text("Fertitilty").tag(ResourceMapStyle.fertility)
                Text("Gold").tag(ResourceMapStyle.gold)
                Text("Minerals").tag(ResourceMapStyle.mine)
                Text("Oil").tag(ResourceMapStyle.oil)
                Text("Uranium").tag(ResourceMapStyle.uranium)
            }.pickerStyle(.segmented)
        }
    }

    func cellText(_ cell: Cell) -> String {
        let map_coord = screenToMapCoord(cell.coordinates)
        if let sector = game_map[map_coord] {
            return sector.symbol
        } else {
            return "\(map_coord.x),\(map_coord.y)"
        }
    }

    func edgeColour(_ cell: Cell) -> GraphicsContext.Shading {
        let defaultColour: GraphicsContext.Shading = .color(
            red: 0.65,
            green: 0.9,
            blue: 1.0
        )
        let foundColour: GraphicsContext.Shading = .color(
            red: 1.0,
            green: 0.1,
            blue: 0.1
        )
        switch displayUnitMapStyle {
        case .none:
            return defaultColour
        case .ship:
            for (_, ship) in ships {
                if ship.coords == MapCoord(cell.coordinates) {
                    return foundColour
                }
            }
            return defaultColour
        case .plane:
            return defaultColour
        case .land:
            return defaultColour
        }
    }

    func cellColour(_ cell: Cell) -> GraphicsContext.Shading {
        switch displayResourceMapStyle {
        case .normal:
            return cellColourNormal(cell)
        case .fertility:
            return cellColourBySector(cell, mapkey: .fert)
        case .mine:
            return cellColourBySector(cell, mapkey: .min)
        case .oil:
            return cellColourBySector(cell, mapkey: .ocontent)
        case .uranium:
            return cellColourBySector(cell, mapkey: .uran)
        case .gold:
            return cellColourBySector(cell, mapkey: .gold)
        //        default:
        //            return cellColourNormal(cell)
        }
    }

    func cellColourNormal(_ cell: Cell) -> GraphicsContext.Shading {
        do {
            if cell == hexmap.cellAt(try CubeCoordinates(x: 0, y: 0, z: 0))! {
                return .color(Color.red)
            }
        } catch { print("cellColour: No center of hexmap") }
        let map_coord = screenToMapCoord(cell.coordinates)
        if let sector = game_map[map_coord] {
            if sector.owned {
                return .color(Color.mint)
            }
            switch sector.desig.desig {
            case .sea:
                return .color(Color.blue)
            case .wilderness:
                return .color(Color.green)
            case .mountain:
                return .color(Color.gray)
            default:
                return .color(Color.clear)
            }
        }
        return .color(Color.clear)
    }

    func cellColourBySector(_ cell: Cell, mapkey: MapKey)
        -> GraphicsContext.Shading
    {
        let map_coord = screenToMapCoord(cell.coordinates)
        if let sector = game_map[map_coord] {
            if sector.desig.desig == .sea {
                return .color(Color.blue)
            }
            do {
                if let val = sector[mapkey] {
                    let val_ratio = try (val.toDouble() / 100.0)
                    return .color(
                        .sRGB,
                        red: val_ratio,
                        green: val_ratio,
                        blue: val_ratio
                    )
                }
            } catch {
                return .color(Color.clear)
            }
        }
        return .color(Color.clear)
    }

    /// Adjust screen coordinates to map coordinates
    func screenToMapCoord(_ coord: CubeCoordinates) -> MapCoord {
        var adjusted = MapCoord(coord)
        adjusted.x += center_coord.x
        adjusted.y += center_coord.y
        return adjusted
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            let new_coord = cubeToDoubleWidth(
                from: cell.coordinates,
                orientation: MapConfig.orientation,
                offsetLayout: MapConfig.offsetLayout
            )
            center_coord.x += new_coord.x
            center_coord.y += new_coord.y
        } else {
            print("no cell at \(location.hexPoint)")
        }
    }
}

// MARK: -
#Preview {
    @Previewable var game = Game()
    @Previewable @State var center_coord = MapCoord(x: 0, y: 0)
    MapView(game_map: game.game_map, center_coord: $center_coord, ships: [:])
}
