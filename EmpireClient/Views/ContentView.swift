//
//  ContentView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import HexGrid
import SwiftUI

enum contentType {
    case sector
    case ship
}

struct ContentView: View {
    @State var game: Game
    @State var center_coord: MapCoord
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State private var isLoggedIn: Bool = false
    @FocusState private var focused: Bool

    @State private var showExplorePopup: Bool = false
    @State private var showDesignatePopup: Bool = false
    @State private var showDistributePopup: Bool = false
    @State private var showThresholdPopup: Bool = false
    @State private var showBuildPopup: Bool = false

    @State private var content: contentType = .sector

    var profile = loadSettings()

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List {
                Button("Sector") { content = .sector }
                if !game.ships.isEmpty {
                    Button("Ship") { content = .ship }
                }
            }
        } content: {
            Spacer()
            if !isLoggedIn {
                loginButton
                Spacer()
            } else {
                contentView
            }
        } detail: {
            Spacer()
            detailView
        }
        .navigationSplitViewStyle(.balanced)
        .focusable()
        .onKeyPress { press in
            return keyPressed(press.characters)
        }
        HStack {
            RawCmdView(game: game).frame(maxWidth: 700)
            Spacer()
            LogView(logs: game.logs).scaledToFill()
        }
    }

    var contentView: some View {
        VStack {
            MapView(
                game_map: game.game_map,
                center_coord: $center_coord,
                ships: game.ships
            )
        }
        .navigationSplitViewColumnWidth(min: 300, ideal: 400)
    }

    var detailView: some View {
        VStack {
            switch content {
            case .sector:
                sectorDetailView
            case .ship:
                ShipDetailView(game: game)
            }
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
    }
 
    var sectorDetailView: some View {
        HStack {
            VStack {
                if let sector = game[center_coord] {
                    Text(
                        "\(center_coord.x), \(center_coord.y): \(sector.desig.name)"
                    )
                    .font(.title)
                    SectorView(coord: center_coord, sector: sector)
                        .focusable(true)
                        .focused($focused)
                } else {
                    Text("\(center_coord.x), \(center_coord.y)").font(.title)
                }
            }
            buttonBar
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
        .build(
            isPresented: $showBuildPopup,
            game: game,
            center_coord: center_coord
        )
        .explore(
            isPresented: $showExplorePopup,
            game: game,
            center_coord: center_coord
        )
        .designate(
            isPresented: $showDesignatePopup,
            game: game,
            center_coord: center_coord
        )
        .distribute(
            isPresented: $showDistributePopup,
            game: game,
            center_coord: center_coord
        )
        .threshold(
            isPresented: $showThresholdPopup,
            game: game,
            center_coord: center_coord
        )
    }

    var buttonBar: some View {
        VStack {
            if let sector = game[center_coord] {
                if sector.owned {
                    dumpButton
                    buildButton
                    designateButton
                    distributeButton
                    exploreButton
                    thresholdButton
                }
            }
        }
    }

    var loginButton: some View {
        Button("Login") {
            Task {
                await game.login(
                    country: profile.country,
                    password: profile.password
                )
                await game.get_data()
            }
            isLoggedIn = game.nationReport.count >= 0
        }
    }

    var dumpButton: some View {
        return
            Button("Refresh") {
                Task {
                    await game.get_data()
                }
            }
    }

    var buildButton: some View {
        Button("Build") {
            showBuildPopup = true
        }
    }

    var thresholdButton: some View {
        Button("Threshold") {
            showThresholdPopup = true
        }
    }

    var distributeButton: some View {
        Button("Distribute") {
            showDistributePopup = true
        }
    }

    var exploreButton: some View {
        Button("Explore") {
            showExplorePopup = true
        }
    }

    var designateButton: some View {
        Button("Designate") {
            showDesignatePopup = true
        }
    }

    func keyPressed(_ keys: String) -> KeyPress.Result {
        switch keys {
        case "j":
            center_coord.x += 2
        case "g":
            center_coord.x -= 2
        case "y":
            center_coord.x -= 1
            center_coord.y -= 1
        case "u":
            center_coord.x += 1
            center_coord.y -= 1
        case "b":
            center_coord.x -= 1
            center_coord.y += 1
        case "n":
            center_coord.x += 1
            center_coord.y += 1
        default:
            return .ignored
        }
        return .handled
    }
}


#Preview {
    @Previewable @State var game = Game()
    let mc = MapCoord(x: 0, y: 0)
    ContentView(game: game, center_coord: mc)
}
