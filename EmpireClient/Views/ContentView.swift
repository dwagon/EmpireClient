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

    @State private var showExplorerPopup: Bool = false
    @State private var item: Item = .mil
    @State private var number: Int = 1
    @State private var destination: String = ""

    @State private var showDesignatePopup: Bool = false
    @State private var designation: String = ""

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Text("Sidebar")
        } content: {
            Text("Content")
            Spacer()
            if !isLoggedIn {
                loginButton
                Spacer()
            } else {
                contentView
            }
        } detail: {
            Text("Detail")
            Spacer()
            HStack {
                detailView
                Divider()
                buttonBar
            }
        }
        .navigationSplitViewStyle(.balanced)
        .focusable()
        .onKeyPress { press in
            return keyPressed(press.characters)
        }
        .sheet(
            isPresented: $showExplorerPopup
        ) {
            showExplorerPopup = false
            if number > 0 {
                Task {
                    await game.cmd_explo(
                        item: item,
                        sector: center_coord,
                        number: number,
                        destination: destination
                    )
                    await game.cmd_dump()
                    await game.cmd_bmap()
                    number = 0
                    destination = ""
                    item = .civ
                }
            }
        } content: {
            ExploreView(
                coord: center_coord,
                item: $item,
                number: $number,
                destination: $destination
            )
        }
        .sheet(
            isPresented: $showDesignatePopup
        ) {
            showDesignatePopup = false
            if designation != "" {
                Task {
                    await game.cmd_designate(coord: center_coord, designation: designation)
                    await game.cmd_dump()
                }
            }
        } content: {
            if let sector = game[center_coord] {
                DesignateView(sector: sector, designation: $designation)
            }
        }
    }

    var contentView: some View {
        VStack {
            MapView(game_map: game.game_map, center_coord: $center_coord)
        }
        .navigationSplitViewColumnWidth(min: 300, ideal: 400)
    }

    var detailView: some View {
        VStack {
            if let sector = game[center_coord] {
                Text(
                    "\(center_coord.x), \(center_coord.y): \(sector.description)"
                )
                .font(.title)
                HexView(coord: center_coord, sector: sector)
                    .focusable(true)
                    .focused($focused)
            } else {
                Text("\(center_coord.x), \(center_coord.y)").font(.title)
            }
        }
    }

    var buttonBar: some View {
        VStack {
            if let sector = game[center_coord] {
                if sector.owned {
                    exploreButton
                    designateButton
                }
            }
        }
    }

    var loginButton: some View {
        return HStack {
            Button("Login") {
                Task {
                    await game.login(country: "1", password: "1")
                    await game.cmd_dump()
                    await game.cmd_bmap()
                }
                isLoggedIn = true
            }
        }
    }

    var exploreButton: some View {
        Button("Explore") {
            showExplorerPopup = true
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
