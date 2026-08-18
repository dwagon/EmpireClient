//
//  MapView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import HexGrid
import SwiftUI

enum MapStyle {
    case normal
    case fertility
    case gold
    case mine
    case oil
    case uranium
}

struct MapView: View {
    let game_map: Map
    @State var mapstyle: MapStyle = .normal
    @Binding var center_coord: MapCoord

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
                cellColour: cellColour,
                hexGesture: hexGesture
            )
            Picker("", selection: $mapstyle) {
                Text("Normal").tag(MapStyle.normal)
                Text("Fertitilty").tag(MapStyle.fertility)
                Text("Gold").tag(MapStyle.gold)
                Text("Minerals").tag(MapStyle.mine)
                Text("Oil").tag(MapStyle.oil)
                Text("Uranium").tag(MapStyle.uranium)
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

    func cellColour(_ cell: Cell) -> GraphicsContext.Shading {
        switch mapstyle {
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

    func cellColourBySector(_ cell: Cell, mapkey: MapKey) -> GraphicsContext.Shading {
        let map_coord = screenToMapCoord(cell.coordinates)
        if let sector = game_map[map_coord] {
            if sector.desig.desig == .sea {
                return .color(Color.blue)
            }
            do {
                if let val = sector[mapkey] {
                    let val_ratio = try (val.toDouble() / 100.0)
                    return .color(.sRGB, red: val_ratio, green: val_ratio, blue: val_ratio)
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
    MapView(game_map: game.game_map, center_coord: $center_coord)
}
