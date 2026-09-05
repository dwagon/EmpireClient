//
//  ContentView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import HexGrid
import SwiftUI

enum ContentType {
    case sector
    case ship
}

struct ContentView: View {
    @State var game: Game
    @State var centerCoord: MapCoord
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State private var isLoggedIn: Bool = false
    @FocusState private var focused: Bool

    @State private var content: ContentType = .sector

    var profile = loadSettings()

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List {
                Button("Sector") { content = .sector }
                    .foregroundStyle(content == .sector ? .blue : .secondary)
                if !game.ships.isEmpty {
                    Button("Ship") { content = .ship }
                        .foregroundStyle(
                            content == .ship ? .blue : .secondary
                        )
                }
            }
        } content: {
            Spacer()
            if !isLoggedIn {
                loginButton
                Spacer()
            } else {
                displayMapView
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

    var displayMapView: some View {
        MapView(
            gameMap: game.gameMap,
            centerCoord: $centerCoord,
            ships: game.ships
        )
        .navigationSplitViewColumnWidth(min: 300, ideal: 400)
    }

    var detailView: some View {
        Group {
            switch content {
            case .sector:
                SectorDetailView(game: game, centerCoord: centerCoord)
            case .ship:
                ShipDetailView(game: game, centerCoord: $centerCoord)
            }
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
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
                }
                isLoggedIn = game.nationReport.count >= 0
            }
        }
    }

    func keyPressed(_ keys: String) -> KeyPress.Result {
        switch keys {
        case "j":
            centerCoord.x += 2
        case "g":
            centerCoord.x -= 2
        case "y":
            centerCoord.x -= 1
            centerCoord.y -= 1
        case "u":
            centerCoord.x += 1
            centerCoord.y -= 1
        case "b":
            centerCoord.x -= 1
            centerCoord.y += 1
        case "n":
            centerCoord.x += 1
            centerCoord.y += 1
        default:
            return .ignored
        }
        return .handled
    }
}

#Preview {
    @Previewable @State var game = Game()
    let mc = MapCoord(x: 0, y: 0)
    ContentView(game: game, centerCoord: mc)
}
