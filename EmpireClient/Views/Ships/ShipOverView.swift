//
//  ShipOverView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/9/2026.
//

import SwiftUI

enum ShipViewMode {
    case overview
    case navigate
    case load
    case unload
    case name
    case fleetAdd
    case tend
    case upgrade
}

struct ShipOverView: View {
    var game: Game
    @Binding var centerCoord: MapCoord
    @State var viewMode: ShipViewMode = .overview
    @State private var selectedShip: Ship.ID?

    var body: some View {
        VStack {
            Spacer()
            Group {
                if let selectedShip, let ship = game.ships[selectedShip] {
                    ShipDetailView(game: game, ship: ship)
                    Divider()
                    Spacer()
                } else {
                    Text("Ship not selected").padding()
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
                ShipButtonBar(
                    game: game,
                    selectedShip: $selectedShip,
                    viewMode: $viewMode
                )
            }
            Spacer()
        }
    }

    @ViewBuilder
    var tableView: some View {
        ShipTableView(
            game: game,
            centerCoord: $centerCoord,
            selectedShip: $selectedShip
        )
    }

    @ViewBuilder
    var operationView: some View {
        if let selectedShip, let ship = game.ships[selectedShip] {
            switch viewMode {
            case .overview:
                EmptyView()  // Should never occur
            case .navigate:
                NavigateView(
                    game: game,
                    ship: ship,
                    destination: $centerCoord,
                    viewMode: $viewMode
                )
            case .load:
                LoadShipView(
                    game: game,
                    ship: ship,
                    viewMode: $viewMode
                )
            case .unload:
                UnloadShipView(
                    game: game,
                    ship: ship,
                    viewMode: $viewMode
                )
            case .name:
                NameShipView(
                    game: game,
                    ship: ship,
                    viewMode: $viewMode
                )
            case .fleetAdd:
                FleetAddView(
                    game: game,
                    ship: ship,
                    viewMode: $viewMode
                )
            case .tend:
                TendShipView(game: game, ship: ship, viewMode: $viewMode)
            case .upgrade:
                ShipUpgradeView(game: game, ship: ship, viewMode: $viewMode)
            }
        }
    }
}
