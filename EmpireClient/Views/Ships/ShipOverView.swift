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
}

struct ShipOverView: View {
    var game: Game
    @Binding var centerCoord: MapCoord
    @State var viewMode: ShipViewMode = .overview
    @State private var selectedShip: Ship.ID?

    @State private var showLoadPopup: Bool = false
    @State private var showUnloadPopup: Bool = false
    @State private var showNavigatePopup: Bool = false
    @State private var showAssaultPopup: Bool = false
    @State private var showNamePopup: Bool = false
    @State private var showFleetAddPopup: Bool = false

    var body: some View {
        HStack {
            switch viewMode {
            case .overview:
                ShipTableView(game: game, centerCoord: $centerCoord, selectedShip: $selectedShip)
            case .navigate:
                NavigateView(game: game, selectedShip: selectedShip, destination: $centerCoord, viewMode: $viewMode)
            case .load:
                LoadShipView(game: game, selectedShip: selectedShip, viewMode: $viewMode)
            case .unload:
                UnloadShipView(game: game, selectedShip: selectedShip, viewMode: $viewMode)
            case .name:
                NameShipView(game: game, selectedShip: selectedShip, viewMode: $viewMode)
            }
            Spacer()
            ShipButtonBar(game: game, selectedShip: $selectedShip, viewMode: $viewMode)
        }

//        .assaultShip(
//            isPresented: $showAssaultPopup,
//            game: game,
//            shipId: selectedShip
//        )
//        .fleetAdd(
//            isPresented: $showFleetAddPopup,
//            game: game,
//            shipId: selectedShip
//        )
    }
}
