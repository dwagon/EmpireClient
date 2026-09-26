//
//  ContentView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import HexGrid
import SwiftUI

enum TabChosen {
    case sector
    case ship
    case plane
    case land
    case nuke
}

struct ContentView: View {
    @State var game: Game
    @State var centerCoord: MapCoord
    @State private var isLoggedIn: Bool = false
    @State private var tabSelection: TabChosen = .sector

    var profile = loadSettings()

    var body: some View {
        VStack {
            GeometryReader { geom in
                HStack {
                    Group {
                        if !isLoggedIn {
                            loginButton
                        } else {
                            displayMapView
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            tabSelection = .sector
                                        }
                                )
                        }
                    }
                    .frame(width: geom.size.width / 2)
                    tabbedDetailView
                        .frame(width: geom.size.width / 2)
                }
            }

            HStack {
                RawCmdView(game: game).frame(maxWidth: 600)
                Spacer()
                LogView(logs: game.logs).scaledToFill()
            }
        }
    }

    var tabbedDetailView: some View {
        TabView(selection: $tabSelection) {
            Tab("Sector Details", systemImage: "info", value: .sector) {
                SectorDetailView(game: game, centerCoord: centerCoord)
            }
            Tab("Ships", systemImage: "sailboat", value: .ship) {
                ShipDetailView(game: game, centerCoord: $centerCoord)
            }.disabled(game.ships.isEmpty)
            Tab(
                "Land Units",
                systemImage: "car.rear.road.lane.distance.5",
                value: .land
            ) {
                LandDetailView(game: game, centerCoord: $centerCoord)
            }.disabled(game.landUnits.isEmpty)
            Tab("Planes", systemImage: "airplane.up.right", value: .plane) {
                PlaneDetailView(game: game, centerCoord: $centerCoord)
            }.disabled(game.planes.isEmpty)
            Tab("Nukes", systemImage: "sun.max.trianglebadge.exclamationmark", value: .nuke) {
                NukeDetailView(game: game, centerCoord: $centerCoord)
            }.disabled(game.nukes.isEmpty)
        }
        .onChange(of: tabSelection) { _, newTab in
            switch newTab {
            case .land:
                Task {
                    await game.cmd_ldump()
                }
            case .ship:
                Task {
                    await game.cmd_sdump()
                }
            case .plane:
                Task {
                    await game.cmd_pdump()
                }

            case .nuke:
                Task {
                    await game.cmd_ndump()
                }
            case .sector:
                break
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
        .navigationSplitViewColumnWidth(min: 300, ideal: 400)
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
                    await game.get_initial_data()
                    await game.get_data()
                    await game.get_radar()
                }
                isLoggedIn = game.nationReport.count >= 0
            }
        }
    }
}

#Preview {
    @Previewable @State var game = Game()
    let mc = MapCoord(x: 0, y: 0)
    ContentView(game: game, centerCoord: mc)
}
