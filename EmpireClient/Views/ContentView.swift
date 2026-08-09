//
//  ContentView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import HexGrid
import SwiftData
import SwiftUI

struct ContentView: View {
    @State var game: Game
    @State var center_coord: MapCoord
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn
    @State private var isLoggedIn: Bool = false
    @FocusState private var focused: Bool

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Text("Sidebar")
        } content: {
            MapView(game_map: game.game_map, center_coord: $center_coord)
                .navigationTitle("Map")
                .navigationSplitViewColumnWidth(min: 200, ideal: 300, max: 300)
        } detail: {
            if let sector = game[center_coord] {
                Text("\(center_coord.x), \(center_coord.y): \(sector.repr)")
                    .font(.title)
                HexView(coord: center_coord, sector: sector)
                    .focusable(true)
                    .focused($focused)
            } else {
                Text("\(center_coord.x), \(center_coord.y)").font(.title)
            }
            if !isLoggedIn {
                Button("Login") {
                    Task {
                        await game.login(country: "1", password: "1")
                    }
                    isLoggedIn = true
                }
            }
            Button("Dump") {
                Task {
                    await game.cmd_dump()
                }
            }
            Button("Map") {
                Task {
                    await game.cmd_bmap()
                }
            }
        }.navigationSplitViewStyle(.balanced)
            .focusable()
            .onKeyPress { press in
                return keyPressed(press.characters)
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
    //    let s = Sector(coords: mc)
    //    game.game_map[mc] = s

    ContentView(game: game, center_coord: mc)
        .modelContainer(for: Item.self, inMemory: true)
}
