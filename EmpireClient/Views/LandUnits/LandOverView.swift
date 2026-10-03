//
//  LandOverView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/9/2026.
//

import SwiftUI

enum LandViewMode {
    case overview
    case march
    case load
    case upgrade
    case fortify
}

struct LandOverView: View {
    var game: Game
    @Binding var centerCoord: MapCoord
    @State private var selectedUnit: LandUnit.ID?
    @State var viewMode: LandViewMode = .overview

    var body: some View {
        VStack {
            Spacer()
            Group {
                if let selectedUnit, let unit = game.landUnits[selectedUnit] {
                    LandDetailView(game: game, unit: unit)
                    Divider()
                    Spacer()
                } else {
                    Text("Unit not selected").padding()
                }
            }.border(.blue)

            HStack(alignment: .center) {
                Spacer()
                if viewMode == .overview {
                    tableView
                } else {
                    operationView
                }
                Spacer()
                LandButtonBar(
                    game: game,
                    selectedUnit: $selectedUnit,
                    viewMode: $viewMode
                )
            }
            Spacer()
        }
    }

    @ViewBuilder
    var tableView: some View {
        LandTableView(
            game: game,
            centerCoord: $centerCoord,
            selectedUnit: $selectedUnit
        )
    }

    @ViewBuilder
    var operationView: some View {
        if let selectedUnit, let unit = game.landUnits[selectedUnit] {
            switch viewMode {
            case .overview:
                EmptyView()  // Should never occur
            case .load:
                LandLoadView(game: game, unit: unit, viewMode: $viewMode)
            case .march:
                MarchView(
                    game: game,
                    unit: unit,
                    destination: $centerCoord,
                    viewMode: $viewMode
                )
            case .upgrade:
                LandUpgradeView(game: game, unit: unit, viewMode: $viewMode)
            case .fortify:
                FortifyView(game: game, unit: unit, viewMode: $viewMode)

            }
        }
    }
}
