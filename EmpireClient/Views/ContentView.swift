//
//  ContentView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import HexGrid
import SwiftUI

struct ContentView: View {
    var game: Game
    @State var centerCoord: MapCoord
    @State private var isLoggedIn: Bool = false
    @State var tabSelection: TabChosen = .sector
    @State var sectorSelect: Bool = true       // Click on a sector to view the sector

    var profile = loadSettings()

    var body: some View {
        VStack {
            if !isLoggedIn {
                loginButton
            } else {
                GeometryReader { geom in
                    HStack {
                        displayMapView
                            .frame(width: geom.size.width * 0.45)
                            .simultaneousGesture(
                                TapGesture().onEnded { tabSelection = .sector },
                                isEnabled: sectorSelect
                            )

                        TabbedDetailView(
                            game: game,
                            selectedTab: $tabSelection,
                            centerCoord: $centerCoord,
                            sectorSelect: $sectorSelect
                        )
                        .frame(width: geom.size.width * 0.55)
                    }
                }

                HStack {
                    RawCmdView(game: game).frame(maxWidth: 600)
                    Spacer()
                    LogView(logs: game.logs).scaledToFill()
                }
            }
        }
    }

    var displayMapView: some View {
        MapView(
            game: game,
            centerCoord: $centerCoord,
            ships: game.ships,
            landUnits: game.landUnits,
            planes: game.planes,
            nukes: game.nukes
        )
    }

    var loginButton: some View {
        if profile.country.isEmpty || profile.password.isEmpty {
            Button("Set Country / Password first") {}
        } else {
            Button("Login") {
                Task {
                    await game.login(
                        country: profile.country,
                        password: profile.password
                    )
                    await game.get_data()
                    await game.get_initial_data()
                    await game.get_radar()
                }
                isLoggedIn = true
            }
        }
    }
}

#Preview {
    @Previewable @State var game = Game()
    let mc = MapCoord(x: 0, y: 0)
    ContentView(game: game, centerCoord: mc)
}
