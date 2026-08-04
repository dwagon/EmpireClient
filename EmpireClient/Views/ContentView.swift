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
    var game: Game
    @State var center_coord: MapCoord
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Text("Sidebar")
        } content: {
            MapView(game_map: game.game_map, center_coord: $center_coord)
                .navigationTitle("Map")
                .navigationSplitViewColumnWidth(min: 200, ideal: 300, max: 300)
        } detail: {
            Text("\(center_coord.x), \(center_coord.y)").font(.title)
            if let sector = game.sector(game.coord) {
                HexView(coord: center_coord, sector: sector)
            }
            if !game.loggedIn {
                Button("Login") {
                    Task {
                        await game.login(country: "1", password: "1")
                    }
                }
            }
        }.navigationSplitViewStyle(.balanced)
    }

}

#Preview {
    @Previewable @State var game = Game()

    ContentView(game: game, center_coord: MapCoord(x: 0, y: 0))
    //     .modelContainer(for: Item.self, inMemory: true)
}
