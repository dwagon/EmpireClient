//
//  MarchView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/9/2026.
//

import HexGrid
import SwiftUI

struct MarchView: View {
    var unitNum: String
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
                    destination == nil ? "March unit \(unitNum) to a location" :
                    "March \(unitNum) to \(destination!.toString())"
                )
            }.padding()
            HStack {
                Button("Finish") {
                    dismiss()
                }
            }.buttonStyle(.automatic)
        }.padding()
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            destination = cubeToDoubleWidth(
                from: cell.coordinates
            )
            destination! += game.landUnits[unitNum]!.coords
            Task {
                await game.cmd_march(
                    unit: unitNum,
                    destination: destination!
                )
                await game.cmd_ldump(unitNum)
            }
        } else {
            print("no cell at \(location.hexPoint)")
        }
    }

    func cellText(_ cell: Cell) -> String {
        let mapCoord = screenToMapCoord(
            cell.coordinates,
            centerCoord: game.landUnits[unitNum]!.coords
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
            center: game.landUnits[unitNum]!.coords
        )
    }
}

struct MarchUnitSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var unitId: LandUnit.ID?
    
    func body(content: Content) -> some View {
        if let unitId {
            content
                .sheet(
                    isPresented: $isPresented
                ) {
                    isPresented = false
                } content: {
                    MarchView(
                        unitNum: game.landUnits[unitId]!.number,
                        game: game
                    )
                }
        } else {
            content
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
