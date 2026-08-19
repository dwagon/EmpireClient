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

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Label("Set Threshold", systemImage: "lessthanorequalto").font(
                .title
            )
            HStack {
                ThresholdDetails.padding()
                Spacer()
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

    var ThresholdDetails: some View {
        return VStack {
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

struct View_Threshold: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var center_coord: MapCoord
    @State private var item: Item = .none
    @State private var level = 0.0

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                isPresented = false
                if item != .none {
                    Task {
                        await game.cmd_threshold(
                            item: item,
                            coord: center_coord,
                            level: Int(level)
                        )
                        await game.cmd_dump()
                        item = .none
                        level = 0.0
                    }
                }
            } content: {
                ThresholdView(
                    coord: center_coord,
                    item: $item,
                    level: $level,
                )
            }
    }
}

extension View {
    func threshold(
        isPresented: Binding<Bool>,
        game: Game,
        center_coord: MapCoord
    ) -> some View {
        modifier(
            View_Threshold(
                isPresented: isPresented,
                game: game,
                center_coord: center_coord
            )
        )
    }
}

#Preview {
    @Previewable var coord = MapCoord(x: 0, y: 0)
    @Previewable @State var item: Item = .none
    @Previewable @State var level: Double = 0.0

    ThresholdView(
        coord: coord,
        item: $item,
        level: $level
    )
}
