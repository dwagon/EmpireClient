//
//  PlaneOverView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 2/10/2026.
//

import SwiftUI

enum PlaneViewMode {
    case overview
    case upgrade
}

struct PlaneOverView: View {
    var game: Game
    @Binding var centerCoord: MapCoord
    @State var viewMode: PlaneViewMode = .overview
    @State private var selectedPlane: Plane.ID?

    var body: some View {
        VStack {
            if let selectedPlane, let plane = game.planes[selectedPlane] {
                PlaneDetailView(game: game, plane: plane)
                Divider()
                Spacer()
            } else {
                Text("Plane not selected")
            }
            HStack(alignment: .center) {
                Spacer()
                if viewMode == .overview {
                    tableView
                } else {
                    operationView
                }
                Spacer()
                PlaneButtonBar(
                    game: game,
                    selectedPlane: $selectedPlane,
                    viewMode: $viewMode
                )
            }
            Spacer()
        }
    }

    @ViewBuilder
    var tableView: some View {
        PlaneTableView(
            game: game,
            centerCoord: $centerCoord,
            selectedPlane: $selectedPlane
        )
    }

    @ViewBuilder
    var operationView: some View {
        if let selectedPlane, let plane = game.planes[selectedPlane] {
            switch viewMode {
            case .overview:
                EmptyView()  // Should never occur
            case .upgrade:
                PlaneUpgradeView(game: game, plane: plane, viewMode: $viewMode)
            }
        }
    }
}
