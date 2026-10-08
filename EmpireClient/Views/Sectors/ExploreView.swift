//
//  ExploreView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 11/8/2026.
//

import HexGrid
import SwiftUI

struct ExploreView: View {
    var game: Game
    var sector: Sector
    @Binding var sectorSelect: Bool
    @Binding var viewMode: SectorViewMode

    @State var item: Item
    @State var number: Int
    @State var destination: String?
    @State var destinationCell: Cell?

    init(game: Game, sector: Sector, sectorSelect: Binding<Bool>, viewMode: Binding<SectorViewMode>) {
        self.game = game
        self.sector = sector
        self._sectorSelect = sectorSelect
        self._viewMode = viewMode
        self.item = .mil
        self.number = 1
    }
    
    var hexmap = HexGrid(
        shape: .hexagon(4),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize
    )

    var body: some View {
        VStack {
            Label("Explore new territory", systemImage: "map.fill").font(.title)
            HStack {
                DrawHex(
                    hexmap: hexmap,
                    radius: 4,
                    cellText: cellText,
                    cellFillColour: cellColour,
                    hexGesture: hexGesture
                ).scaledToFit()
                exploreDetails.padding()
                Spacer()
            }
            HStack {
                CancelButton() {
                    viewMode = .overview
                    sectorSelect = false
                }
                OkButton("Explore", disabled:destination == nil || number == 0) {
                    if let destination {
                        doExplore(game: game, item: item, centerCoord: sector.coords, number: number, destination: destination)
                        viewMode = .overview
                        sectorSelect = false
                    }
                }
            }
        }
    }

    var exploreDetails: some View {
        return VStack {
            Picker(
                "Use",
                selection: $item,
                content: {
                    Text("Military (\(sector.cargo[.mil] ?? 0))").tag(
                        Item.mil
                    )
                    Text("Civilians (\(sector.cargo[.civ] ?? 0))").tag(
                        Item.civ
                    )
                }
            )
            .pickerStyle(.inline)
            .padding()
            let str =
                "Send \(number) "
                + ((item == Item.mil) ? "military" : "civilians")
            let max = max(1, sector.cargo[item] ?? 1)

            Stepper(
                str,
                value: $number,
                in: 1...max
            )
        }
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            destination = directionString(cell)
            destinationCell = cell
        } else {
            print("no cell at \(location.hexPoint)")
        }
    }

    func cellText(_ cell: Cell) -> String {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: sector.coords
        )
        if let sector = game.gameMap[mapCoord] {
            return sector.symbol
        } else {
            return "\(mapCoord.toString())"
        }
    }

    func cellColour(_ cell: Cell) -> GraphicsContext.Shading {
        if let destinationCell {
            if cell == destinationCell {
                return .color(Color.red)
            }
        }
        return mapCellColour(
            cell: cell,
            gameMap: game.gameMap,
            hexmap: hexmap,
            center: sector.coords
        )
    }
}

func doExplore(game: Game, item: Item, centerCoord: MapCoord, number: Int, destination: String) {
    Task {
        await game.cmd_explo(
            item: item,
            sector: centerCoord,
            number: number,
            destination: destination
        )
        await game.cmd_dump()
        await game.cmd_map()
    }
}
