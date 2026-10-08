//
//  OptimizeView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 8/9/2026.
//

import SwiftUI

enum OptimizeType: Hashable {
    case none
    case individual
    case global
    case desig(Desig)
}

struct OptimizeView: View {
    var game: Game
    var sector: Sector
    @Binding var viewMode: SectorViewMode
    @State var optimizeType: OptimizeType = .none

    var body: some View {
        VStack {
            Spacer()
            Label("Optimize Thresholds", systemImage: "cloud.rainbow.crop")
                .font(
                    .title
                )
                optimizeDetails.padding()
                Spacer()
            switch optimizeType {
            case .none:
                EmptyView()
            case .individual:
                Text("Optimize at \(sector.coords.toString())")
            case .global:
                Text("Optimize everywhere")
            case .desig(let desig):
                Text("Optimize all \(desig.name)s")
            }
            HStack {
                CancelButton {
                    viewMode = .overview
                }
                OkButton("Optimize") {
                    doOptimize(
                        game: game,
                        sector: sector,
                        optimizeType: optimizeType
                    )
                    viewMode = .overview
                }
            }
        }
    }

    var optimizeDetails: some View {
        return
            Picker(
                "Target",
                selection: $optimizeType,
                content: {
                    Text("Global").tag(OptimizeType.global)
                    Text("Just \(sector.coords.toString())").tag(
                        OptimizeType.individual
                    )
                    Text("All \(sector.desig.name)").tag(
                        OptimizeType.desig(sector.desig)
                    )
                }
            ).pickerStyle(.segmented)
            .pickerStyle(.automatic)
            .padding()
    }
}

func doOptimize(game: Game, sector: Sector, optimizeType: OptimizeType) {
    Task {
        switch optimizeType {
        case .none:
            break
        case .individual:
            game.optimize(coord: sector.coords)
        case .global:
            game.optimize()
        case .desig(let desig):
            game.optimize(desig: desig)
        }
        await game.cmd_dump()
    }
}
