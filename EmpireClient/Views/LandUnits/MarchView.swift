//
//  MarchView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/9/2026.
//

import HexGrid
import SwiftUI

struct MarchView: View {
    var unit: LandUnit
    var game: Game
    @State var destination: MapCoord? = nil

    @Environment(\.dismiss) var dismiss

    var hexmap = HexGrid(
        shape: .hexagon(4),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize
    )

    var body: some View {
        VStack {
            Label(
                "March Unit",
                systemImage: "figure.walk"
            )
            .font(
                .title
            )
            HStack {
                DrawHex(
                    hexmap: hexmap,
                    radius: 5,
                    cellText: cellText,
                    cellFillColour: cellColour,
                    hexGesture: hexGesture
                ).scaledToFit()
                Text(
                    destination == nil
                        ? "March unit \(unit.number) to a location"
                        : "March \(unit.number) to \(destination!.toString())"
                )
            }.padding()
            HStack {
                OkButton("Finish")
            }
        }.padding()
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            destination = cubeToDoubleWidth(
                from: cell.coordinates
            )
            destination! += unit.coords
            Task {
                await game.cmd_march(
                    unit: unit,
                    destination: destination!
                )
                await game.cmd_ldump(unit)
            }
        } else {
            print("no cell at \(location.hexPoint)")
        }
    }

    func cellText(_ cell: Cell) -> String {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: unit.coords
        )
        if let sector = game.gameMap[mapCoord] {
            return sector.symbol
        } else {
            return "\(mapCoord.toString())"
        }
    }

    func cellColour(_ cell: Cell) -> GraphicsContext.Shading {
        return mapCellColour(
            cell: cell,
            gameMap: game.gameMap,
            hexmap: hexmap,
            center: unit.coords
        )
    }
}

struct MarchUnitSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var unitId: LandUnit.ID?

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                if let unitId, let unit = game.landUnits[unitId] {
                    MarchView(
                        unit: unit,
                        game: game
                    )
                }
            }
    }
}

extension View {
    func marchUnit(
        isPresented: Binding<Bool>,
        game: Game,
        unitId: LandUnit.ID?
    ) -> some View {
        modifier(
            MarchUnitSheet(
                isPresented: isPresented,
                game: game,
                unitId: unitId
            )
        )
    }
}

//#Preview {
//    MarchView()
//}
