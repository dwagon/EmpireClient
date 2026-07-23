//
//  ContentView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State var game: Game
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @State var map_coord = MapCoord(x: 0, y: 0)

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Text("Sidebar")
        } content: {
            MapView(game_map: game.game_map, map_coord: map_coord)
                .navigationTitle("Map")
        } detail: {
            Text("Detail")
        }
    }

}

#Preview {
    @Previewable @State var game = Game()

    ContentView(game: game)
    //     .modelContainer(for: Item.self, inMemory: true)
}
