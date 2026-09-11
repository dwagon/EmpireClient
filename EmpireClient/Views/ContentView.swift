//
//  ContentView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import HexGrid
import SwiftUI

struct ContentView: View {
    @State var game: Game
    @State var centerCoord: MapCoord
    @State private var isLoggedIn: Bool = false
    @FocusState private var focused: Bool

    var profile = loadSettings()

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
            Group {
                if !isLoggedIn {
                    loginButton
                } else {
                    displayMapView
                }
            }.navigationSplitViewColumnWidth(800)
                .toolbar(removing: .sidebarToggle)
        } detail: {
            Spacer()
            TabView {
                Tab("Sector Details", systemImage: "info") {
                    SectorDetailView(game: game, centerCoord: centerCoord)
                }
                Tab("Ships", systemImage: "sailboat") {
                    ShipDetailView(game: game, centerCoord: $centerCoord)
                }
            }
        }
        .focusable()
        .onKeyPress { press in
            return keyPressed(press.characters)
        }
        HStack {
            RawCmdView(game: game).frame(maxWidth: 600)
            Spacer()
            LogView(logs: game.logs).scaledToFill()
        }
    }

    var displayMapView: some View {
        MapView(
            game: game,
            centerCoord: $centerCoord,
            ships: game.ships
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
