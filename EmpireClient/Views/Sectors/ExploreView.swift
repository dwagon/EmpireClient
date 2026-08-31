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
                    cellFillColour: cellColour,
                    hexGesture: hexGesture
                ).scaledToFit()
                exploreDetails.padding()
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

    var exploreDetails: some View {
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

    func cellColour(_ cell: Cell) -> GraphicsContext.Shading {
        if destination == directionString(cell) {
            return .color(Color.red)
        }
        return .color(Color.clear)
    }

    func cellText(_ cell: Cell) -> String {
        return directionString(cell)
    }
}

struct ExploreSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var centerCoord: MapCoord
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
                        sector: centerCoord,
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
                coord: centerCoord,
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
        centerCoord: MapCoord
    ) -> some View {
        modifier(
            ExploreSheet(
                isPresented: isPresented,
                game: game,
                centerCoord: centerCoord
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
