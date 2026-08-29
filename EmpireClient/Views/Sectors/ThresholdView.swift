//
//  ThresholdView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 19/8/2026.
//

import SwiftUI

struct ThresholdView: View {
    var coord: MapCoord
    @Binding var item: Item
    @Binding var level: Double
    @Binding var isEverywhere: Bool

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
            Text("Set threshold of \(item.displayName) \(isEverywhere ? "everywhere" : "at \(coord.toString())") to \(Int(level))")
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
            Toggle("Set for everywhere not just \(coord.toString())", isOn: $isEverywhere)
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
    @State private var isEverywhere: Bool = true

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                isPresented = false
                if item != .none {
                    Task {
                        if isEverywhere {
                            await game.cmd_threshold(
                                item: item,
                                level: Int(level)
                                )
                        } else {
                            await game.cmd_threshold(
                                item: item,
                                coord: centerCoord,
                                level: Int(level)
                            )}
                        await game.cmd_dump()
                        item = .none
                        level = 0.0
                    }
                }
            } content: {
                ThresholdView(
                    coord: centerCoord,
                    item: $item,
                    level: $level,
                    isEverywhere: $isEverywhere
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
    @Previewable var coord = MapCoord(x: 0, y: 0)
    @Previewable @State var item: Item = .none
    @Previewable @State var level: Double = 0.0
    @Previewable @State var isEverywhere: Bool = true

    ThresholdView(
        coord: coord,
        item: $item,
        level: $level,
        isEverywhere: $isEverywhere
    )
}
