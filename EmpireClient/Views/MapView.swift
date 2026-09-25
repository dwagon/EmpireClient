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

enum ExtraMapStyle {
    case none
    case distribution
    case efficiency
    case realm
}

let colourChoices: [GraphicsContext.Shading] = [
    .color(.brown), .color(.pink), .color(.gray), .color(.orange),
    .color(.green),
    .color(.yellow), .color(.teal),
]

struct MapView: View {
    let game: Game
    @Binding var centerCoord: MapCoord
    let ships: [ShipNum: Ship]
    let landUnits: [LandNum: LandUnit]
    let planes: [PlaneNum: Plane]
    @State var distroMap: [MapCoord: GraphicsContext.Shading] = [:]
    @State var realmMap: [RealmNum: GraphicsContext.Shading] = [:]

    @State var displayResourceMapStyle: ResourceMapStyle = .normal
    @State var displayUnitMapStyle: UnitMapStyle = .none
    @State var displayExtraMapStyle: ExtraMapStyle = .none
    let radius: Int = 20

    var hexmap = HexGrid(
        shape: .hexagon(20),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize
    )

    var body: some View {
        VStack {
            DrawHex(
                hexmap: hexmap,
                radius: radius,
                cellText: cellText,
                cellFillColour: cellColour,
                cellOpacity: cellOpacity,
                hexGesture: hexGesture
            )

            Picker("", selection: $displayUnitMapStyle) {
                Text("Normal").tag(UnitMapStyle.none)
                Text("Ship").tag(UnitMapStyle.ship)
                Text("Plane").tag(UnitMapStyle.plane)
                Text("Land Unit").tag(UnitMapStyle.land)
            }.pickerStyle(.segmented)
                .onChange(of: displayUnitMapStyle) {
                    displayResourceMapStyle = .normal
                    displayExtraMapStyle = .none
                }
            Picker("", selection: $displayResourceMapStyle) {
                Text("Normal").tag(ResourceMapStyle.normal)
                Text("Fertitilty").tag(ResourceMapStyle.fertility)
                Text("Gold").tag(ResourceMapStyle.gold)
                Text("Minerals").tag(ResourceMapStyle.mine)
                Text("Oil").tag(ResourceMapStyle.oil)
                Text("Uranium").tag(ResourceMapStyle.uranium)
            }.pickerStyle(.segmented)
                .onChange(of: displayResourceMapStyle) {
                    displayUnitMapStyle = .none
                    displayExtraMapStyle = .none
                }
            Picker("", selection: $displayExtraMapStyle) {
                Text("Normal").tag(ExtraMapStyle.none)
                Text("Distribution").tag(ExtraMapStyle.distribution)
                Text("Efficiency").tag(ExtraMapStyle.efficiency)
                Text("Realm").tag(ExtraMapStyle.realm)
            }.pickerStyle(.segmented)
                .onChange(of: displayExtraMapStyle) {
                    displayUnitMapStyle = .none
                    displayResourceMapStyle = .normal
                }
        }.onChange(of: game.gameMap.updated) {
            setDistroMap()
        }
        .onChange(of: game.realms) {
            setRealmMap()
        }
    }

    func setDistroMap() {
        var distroColourChoices = colourChoices
        for sector in game.gameMap.allSectors().filter({ $0.owned }) {
            if let distX = sector[.distX], let distY = sector[.distY] {
                if let distro = MapCoord(x: distX, y: distY) {
                    if distro == sector.coords {
                        continue
                    }
                    if !distroMap.contains(where: { $0.key == distro }) {
                        distroMap[distro] = distroColourChoices.popLast()
                    }
                }
            }
        }
    }

    func setRealmMap() {
        var realmColourChoices = colourChoices
        for realm in game.realms.keys {
            realmMap[realm] = realmColourChoices.popLast()
        }
    }

    /// Return a string repr of ships in a cell ("F" if multiple ships, otherwise the ship type)
    func shipText(_ coord: MapCoord) -> String? {
        let ships = game.ships.filter({ $0.value.coords == coord })
        if ships.count > 1 { return "F" }
        if ships.count == 1 { return Array(ships.values)[0].abbrev }
        return nil
    }

    func cellText(_ cell: Cell) -> String {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: centerCoord
        )
        if let sector = game.gameMap[mapCoord] {
            if lowPriDesigs.contains(sector.desig.desig) {
                if let shipText = shipText(mapCoord) {
                    return shipText
                }
            }
            return sector.symbol
        } else {
            return "\(mapCoord.toString())"
        }
    }

    func cellOpacity(_ cell: Cell) -> Double {
        if cell == hexmap.cellAt(try! CubeCoordinates(x: 0, y: 0, z: 0))! {
            return 0.25
        }
        return 1.0
    }

    func cellColour(_ cell: Cell) -> GraphicsContext.Shading {
        if cell == hexmap.cellAt(try! CubeCoordinates(x: 0, y: 0, z: 0))! {
            return .color(Color.orange)
        }
        if let unitColour = cellColourUnit(cell) {
            return unitColour
        }
        switch displayResourceMapStyle {
        case .normal:
            switch displayExtraMapStyle {
            case .none:
                return cellColourNormal(cell)
            case .distribution:
                return cellColourByDistribution(cell)
            case .efficiency:
                return cellColourByEfficiency(cell)
            case .realm:
                return cellColourByRealm(cell)
            }
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
        }
    }

    func cellColourByRealm(_ cell: Cell) -> GraphicsContext.Shading {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: centerCoord
        )
        let realms = game.inWhichRealm(coord: mapCoord)
        if !realms.isEmpty {
            if realmMap.contains(where: { $0.key == realms[0]} ) {
                return realmMap[realms[0]]!
            }
        }
        return cellColourNormal(cell)
    }

    func cellColourByEfficiency(_ cell: Cell) -> GraphicsContext.Shading {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: centerCoord
        )
        if let sector = game.gameMap[mapCoord] {
            if sector.desig.desig == .sea {
                return .color(Color.blue)
            }
            if !sector.owned {
                return .color(Color.mint)
            }
            do {
                if let val = sector[.eff] {
                    let valRatio = try (val.toDouble() / 100.0)
                    return .color(
                        .sRGB,
                        red: valRatio,
                        green: valRatio,
                        blue: valRatio
                    )
                }
            } catch {
                return .color(Color.clear)
            }
        }
        return .color(.clear)
    }

    /// Return a colour based on what hex we distribute to
    func cellColourByDistribution(_ cell: Cell)
        -> GraphicsContext.Shading
    {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: centerCoord
        )
        if let sector = game.gameMap[mapCoord] {
            if sector.desig.desig == .sea {
                return .color(Color.blue)
            }
            if let distX = sector[.distX], let distY = sector[.distY] {
                let distDest = MapCoord(x: distX, y: distY)
                if distroMap.contains(where: { $0.key == distDest }) {
                    return distroMap[distDest!]!
                }
            }
            /// Owned but no distribution point
            if sector.owned {
                return .color(Color.red)
            }
        }

        return .color(Color.clear)
    }

    /// If we are colouring cells by unit return the colour
    func cellColourUnit(_ cell: Cell) -> GraphicsContext.Shading? {
        let foundColour: GraphicsContext.Shading = .color(.red)
        switch displayUnitMapStyle {
        case .none:
            return nil
        case .ship:
            for (_, ship) in ships
            where ship.coords
                == screenToMapCoord(cell.coordinates, centerCoord: centerCoord)
            {
                return foundColour
            }
        case .plane:
            for (_, unit) in planes
            where unit.coords
                == screenToMapCoord(cell.coordinates, centerCoord: centerCoord)
            {
                return foundColour
            }
        case .land:
            for (_, unit) in landUnits
            where unit.coords
                == screenToMapCoord(cell.coordinates, centerCoord: centerCoord)
            {
                return foundColour
            }
        }
        return nil
    }

    func cellColourNormal(_ cell: Cell) -> GraphicsContext.Shading {
        return mapCellColour(
            cell: cell,
            gameMap: game.gameMap,
            hexmap: hexmap,
            center: centerCoord
        )
    }

    func cellColourBySector(_ cell: Cell, mapkey: MapKey)
        -> GraphicsContext.Shading
    {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: centerCoord
        )
        if let sector = game.gameMap[mapCoord] {
            if sector.desig.desig == .sea {
                return .color(Color.blue)
            }
            do {
                if let val = sector[mapkey] {
                    let valRatio = try (val.toDouble() / 100.0)
                    return .color(
                        .sRGB,
                        red: valRatio,
                        green: valRatio,
                        blue: valRatio
                    )
                }
            } catch {
                return .color(Color.clear)
            }
        }
        return .color(Color.clear)
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            let newCoord = cubeToDoubleWidth(
                from: cell.coordinates
            )
            centerCoord.x += newCoord.x
            centerCoord.y += newCoord.y
        } else {
            print("no cell at \(location.hexPoint)")
        }
    }
}

// MARK: -
#Preview {
    @Previewable var game = Game()
    @Previewable @State var centerCoord = MapCoord(x: 0, y: 0)
    MapView(
        game: game,
        centerCoord: $centerCoord,
        ships: [:],
        landUnits: [:],
        planes: [:]
    )
}
