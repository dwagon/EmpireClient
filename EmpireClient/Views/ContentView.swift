//
//  ContentView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import SwiftData
import SwiftUI
import HexGrid

struct ContentView: View {
    @State var game: Game
    @State var center_coord: MapCoord
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Text("Sidebar")
        } content: {
            MapView(game_map: game.game_map, center_coord: $center_coord)
                .navigationTitle("Map")
                .navigationSplitViewColumnWidth(min: 200, ideal: 300, max: 300)
        } detail: {
            Text("\(center_coord.x), \(center_coord.y)").font(.title)
            if let sector = game[center_coord] {
                HexView(coord: center_coord, sector: sector)
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
