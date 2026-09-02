//
//  SectorDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/8/2026.
//

import SwiftUI

struct SectorDetailView: View {
    var game: Game
    var centerCoord: MapCoord
    @FocusState private var focused: Bool

    @State private var showExplorePopup: Bool = false
    @State private var showDesignatePopup: Bool = false
    @State private var showDistributePopup: Bool = false
    @State private var showThresholdPopup: Bool = false
    @State private var showBuildPopup: Bool = false

    var body: some View {
        HStack {
            VStack {
                if let sector = game[centerCoord] {
                    Text(
                        "\(centerCoord.x), \(centerCoord.y): \(sector.desig.name)"
                    )
                    .font(.title)
                    SectorView(coord: centerCoord, sector: sector)
                        .focusable(true)
                        .focused($focused)
                } else {
                    Text("\(centerCoord.x), \(centerCoord.y)").font(.title)
                }
            }
            sectorButtonBar
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
        .build(
            isPresented: $showBuildPopup,
            game: game,
            centerCoord: centerCoord
        )
        .explore(
            isPresented: $showExplorePopup,
            game: game,
            centerCoord: centerCoord
        )
        .designate(
            isPresented: $showDesignatePopup,
            game: game,
            centerCoord: centerCoord
        )
        .distribute(
            isPresented: $showDistributePopup,
            game: game,
            centerCoord: centerCoord
        )
        .threshold(
            isPresented: $showThresholdPopup,
            game: game,
            centerCoord: centerCoord
        )
    }

    var sectorButtonBar: some View {
        VStack {
            refreshButton
            if let sector = game[centerCoord] {
                if sector.owned {
                    buildButton
                    designateButton
                    distributeButton
                    exploreButton
                    thresholdButton
                }
            }
        }
    }

    var refreshButton: some View {
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
}

#Preview {
    @Previewable @State var game = DataLoader.loadSampleGame(
        name: "Game_ShipView"
    )
    @Previewable @State var centerCoord = MapCoord(x: 0, y: 0)
    SectorDetailView(game: game, centerCoord: centerCoord)
}
