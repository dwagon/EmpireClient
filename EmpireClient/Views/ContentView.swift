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
    @State var map_coord: MapCoord
    @State var center_cell: Cell
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn
    
    init(game: Game, map_coord: MapCoord = MapCoord(x: 10, y: 10)) {
        self.game = game
        self.map_coord = map_coord
        center_cell = game.game_map.grid.cellAt(map_coord)!
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Text("Sidebar")
        } content: {
            MapView(game_map: game.game_map, center_cell: $center_cell)
                .navigationTitle("Map")
                .navigationSplitViewColumnWidth(min: 200, ideal: 300, max: 300)
        } detail: {
            Text("\(map_coord.x), \(map_coord.y)").font(.title)
            if let sector = game.sector(coord: game.coord) {
                HexView(coord: game.coord, sector: sector)
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

    ContentView(game: game)
    //     .modelContainer(for: Item.self, inMemory: true)
}
