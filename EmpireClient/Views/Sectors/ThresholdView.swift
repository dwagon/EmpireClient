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
    var sector: Sector
    @Binding var viewMode: SectorViewMode

    @State var item: Item = .none
    @State var level: Double = 0.0
    @State var threshType: ThresholdType = .individual

    var currentLevel: Int {
        if let amount = sector.distribute[item] {
            return amount
        }
        return 0
    }

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
                    "Set threshold of \(item.displayName) at \(sector.coords.toString()) to \(Int(level))"
                )
            case .global:
                Text(
                    "Set threshold of \(item.displayName) everywhere to \(Int(level))"
                )
            case .desig(let desig):
                Text(
                    "Set threshold of \(item.displayName) at all \(desig.name)s to \(Int(level))"
                )
            }
            Text(
                currentLevel == 0
                    ? ""
                    : "Current Threshold of \(item.displayName) is \(currentLevel)"
            )
            HStack {
                CancelButton {
                    viewMode = .overview
                }
                OkButton("Set Threshold", disabled: item == .none) {
                    doThreshold(game: game, threshType: threshType, coord: sector.coords, item: item, level: Int(level))
                    viewMode = .overview
                }
            }
        }
    }

    var thresholdDetails: some View {
        return VStack {
            Picker(
                "Target",
                selection: $threshType,
                content: {
                    Text("Global").tag(ThresholdType.global)
                    Text("Just \(sector.coords.toString())").tag(
                        ThresholdType.individual
                    )
                    Text("All \(sector.desig.name)").tag(
                        ThresholdType.desig(sector.desig)
                    )
                }
            ).pickerStyle(.segmented)
            ItemPicker(label: "Set", item: $item)
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

func doThreshold(
    game: Game,
    threshType: ThresholdType,
    coord: MapCoord,
    item: Item,
    level: Int
) {
    Task {
        switch threshType {
        case .individual:
            await game.cmd_threshold(
                item: item,
                coord: coord,
                level: level
            )
        case .global:
            await game.cmd_threshold(
                item: item,
                level: level
            )
        case .desig(let desig):
            await game.cmd_threshold(
                item: item,
                desig: desig,
                level: level
            )
        }
        await game.cmd_dump()
    }
}
