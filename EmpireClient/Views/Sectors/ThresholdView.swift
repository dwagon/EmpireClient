//
//  ThresholdView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 19/8/2026.
//

import SwiftUI

enum ThresholdType: Hashable {
    case individual
    case global
    case desig(Desig)
}

struct ThresholdView: View {
    var game: Game
    var coord: MapCoord
    @Binding var item: Item
    @Binding var level: Double
    @Binding var threshType: ThresholdType

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Label("Set Threshold", systemImage: "lessthanorequalto").font(
                .title
            )
            HStack {
                thresholdDetails.padding()
                Spacer()
            }
            switch threshType {
            case .individual:
                Text(
                    "Set threshold of \(item.displayName) at \(coord.toString()) to \(Int(level))"
                )
            case .global:
                Text(
                    "Set threshold of \(item.displayName) everywhere to \(Int(level))"
                )
            case .desig(let desig):
                Text(
                    "Set threshold of \(item.displayName) all \(desig.name) to \(Int(level))"
                )
            }
            HStack {
                Button("Cancel", role: .cancel) {
                    item = .none
                    dismiss()
                }
                .padding()
                Button("Set Threshold") {
                    dismiss()
                }
            }.buttonStyle(.automatic)
        }
    }

    var thresholdDetails: some View {
        return VStack {
            Picker(
                "Target",
                selection: $threshType,
                content: {
                    Text("Global").tag(ThresholdType.global)
                    Text("Just \(coord.toString())").tag(
                        ThresholdType.individual
                    )
                    Text("All \(game.gameMap[coord]!.desig.name)").tag(
                        ThresholdType.desig(game.gameMap[coord]!.desig)
                    )
                }
            ).pickerStyle(.segmented)
            Picker(
                "Set",
                selection: $item,
                content: {
                    ForEach(Item.allCases, id: \.self) { item in
                        Text(item.displayName).tag(item)
                    }
                }
            )
            .pickerStyle(.automatic)
            .padding()
            Slider(value: $level, in: 0...1000, step: 10) {
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1,000")
            }
            Text("\(Int(level))")
        }
    }
}

struct ThresholdSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var centerCoord: MapCoord
    @State private var item: Item = .none
    @State private var level = 0.0
    @State private var threshType: ThresholdType = .global

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                isPresented = false
                if item != .none {
                    Task {
                        switch threshType {
                        case .individual:
                            await game.cmd_threshold(
                                item: item,
                                coord: centerCoord,
                                level: Int(level)
                            )
                        case .global:
                            await game.cmd_threshold(
                                item: item,
                                level: Int(level)
                            )
                        case .desig(let desig):
                            await game.cmd_threshold(
                                item: item,
                                desig: desig,
                                level: Int(level)
                            )
                        }
                        await game.cmd_dump()
                        item = .none
                        level = 0.0
                    }
                }
            } content: {
                ThresholdView(
                    game: game,
                    coord: centerCoord,
                    item: $item,
                    level: $level,
                    threshType: $threshType
                )
            }
    }
}

extension View {
    func threshold(
        isPresented: Binding<Bool>,
        game: Game,
        centerCoord: MapCoord
    ) -> some View {
        modifier(
            ThresholdSheet(
                isPresented: isPresented,
                game: game,
                centerCoord: centerCoord
            )
        )
    }
}

#Preview {
    @Previewable var game = Game()
    @Previewable var coord = MapCoord(x: 0, y: 0)
    @Previewable @State var item: Item = .none
    @Previewable @State var level: Double = 0.0
    @Previewable @State var threshType: ThresholdType = .global

    ThresholdView(
        game: game,
        coord: coord,
        item: $item,
        level: $level,
        threshType: $threshType
    )
}
