//
//  ExploreView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 11/8/2026.
//

import HexGrid
import SwiftUI

struct ExploreView: View {
    var coord: MapCoord
    @Binding var item: Item
    @Binding var number: Int
    @Binding var destination: String

    @Environment(\.dismiss) var dismiss

    var hexmap = HexGrid(
        shape: .hexagon(2),
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
                    cellText: cellText,
                    cellColour: CellColour,
                    hexGesture: hexGesture
                ).scaledToFit()
                ExploreDetails.padding()
                Spacer()
            }
            HStack {
                Button("Explore") {
                    dismiss()
                }
                .buttonStyle(.automatic)
                .padding()
                Button("Cancel", role: .cancel) {
                    number = 0
                    dismiss()
                }
            }
        }
    }

    var ExploreDetails: some View {
        return VStack {
            Picker(
                "Use",
                selection: $item,
                content: {
                    Text("Military").tag(Item.mil)
                    Text("Civilians").tag(Item.civ)
                }
            )
            .pickerStyle(.inline)
            .padding()
            let str =
                "Send \(number) "
                + ((item == Item.mil) ? "military" : "civilians")
            Stepper(
                str,
                value: $number,
                in: 1...1000
            )
        }
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            destination = directionString(cell)
        } else {
            print("no cell at \(location.hexPoint)")
        }
    }

    func CellColour(_ cell: Cell) -> GraphicsContext.Shading {
        if destination == directionString(cell) {
            return .color(Color.red)
        }
        return .color(Color.clear)
    }

    func directionString(_ cell: Cell) -> String {
        let coord = cell.coordinates
        switch (coord.x, coord.y) {
        case (1, 0):
            return "u"
        case (1, -1):
            return "j"
        case (0, -1):
            return "n"
        case (0, 0):
            return "h"
        case (0, 1):
            return "y"
        case (-1, 1):
            return "g"
        case (-1, 0):
            return "b"
        default:
            return "\(coord.x),\(coord.y)"
        }
    }

    func cellText(_ cell: Cell) -> String {
        return directionString(cell)
    }
}

struct View_Explore: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var center_coord: MapCoord
    @State private var item: Item = .mil
    @State private var number: Int = 1
    @State private var destination: String = ""

    func body(content: Content) -> some View {
        content
        .sheet(
            isPresented: $isPresented
        ) {
            isPresented = false
            if number > 0 {
                Task {
                    await game.cmd_explo(
                        item: item,
                        sector: center_coord,
                        number: number,
                        destination: destination
                    )
                    await game.cmd_dump()
                    await game.cmd_bmap()
                    number = 0
                    destination = ""
                    item = .civ
                }
            }
        } content: {
            ExploreView(
                coord: center_coord,
                item: $item,
                number: $number,
                destination: $destination
            )
        }
    }
}

extension View {
    func explore(
        isPresented: Binding<Bool>,
        game: Game,
        center_coord: MapCoord
    ) -> some View {
        modifier(
            View_Explore(
                isPresented: isPresented,
                game: game,
                center_coord: center_coord
            )
        )
    }
}

#Preview {
    @Previewable var coord = MapCoord(x: 0, y: 0)
    @Previewable @State var item: Item = .mil
    @Previewable @State var number: Int = 1
    @Previewable @State var destination: String = ""

    ExploreView(
        coord: coord,
        item: $item,
        number: $number,
        destination: $destination
    )
    let _ = print("item=\(item) number=\(number) destination=\(destination)")
}
