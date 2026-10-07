//
//  SectorOvewView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 7/10/2026.
//

import SwiftUI

enum SectorViewMode {
    case overview
}

struct SectorOverView: View {
    var game: Game
    @Binding var centerCoord: MapCoord
    @State var viewMode: SectorViewMode = .overview

    var body: some View {
        VStack {
            Spacer()
            Group {
                SectorDetailView(game: game, sector: game.gameMap[centerCoord])
                Divider()
                Spacer()

            }.border(.blue)
            HStack(alignment: .center) {
                Spacer()
                if viewMode == .overview {
                    if let sector = game.gameMap[centerCoord] {
                        SectorView(sector: sector)
                    }
                }
                else {
                    operationView
                }
                Spacer()
                    SectorButtonBar(
                        game: game,
                        sector: game.gameMap[centerCoord],
                        viewMode: $viewMode
                    )

            }
            Spacer()
        }
    }

    @ViewBuilder
    var operationView: some View {
        if let sector = game.gameMap[centerCoord] {
            switch viewMode {
            case .overview:
                EmptyView()  // Should never occur
            }
        }
    }
}
