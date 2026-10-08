//
//  SectorOvewView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 7/10/2026.
//

import SwiftUI

enum SectorViewMode {
    case overview
    case build
    case threshold
    case distribute
    case explore
    case designate
    case optimize
}

struct SectorOverView: View {
    var game: Game
    @Binding var centerCoord: MapCoord
    @State var viewMode: SectorViewMode = .overview

    var body: some View {
        VStack {
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
                } else {
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
            case .build:
                BuildView(game: game, sector: sector, viewMode: $viewMode)
            case .threshold:
                ThresholdView(game: game, sector: sector, viewMode: $viewMode)
            case .distribute:
                EmptyView()
            //                DistributeView(coord: <#T##MapCoord#>, warehouses: <#T##[Sector]#>, source: <#T##Binding<DistributeSource>#>, destination: <#T##Binding<MapCoord?>#>, onButton: <#T##() -> Void#>)
            case .explore:
                EmptyView()
            //                ExploreView(game: <#T##Game#>, coord: <#T##MapCoord#>, item: <#T##Binding<Item>#>, number: <#T##Binding<Int>#>, destination: <#T##Binding<String?>#>, onButton: <#T##() -> Void#>)
            case .designate:
                DesignateView(game: game, sector: sector, viewMode: $viewMode)
            case .optimize:
                EmptyView()
            //                OptimizeView(sector: <#T##Sector#>, optimizeType: <#T##Binding<OptimizeType>#>, onButton: <#T##() -> Void#>)
            }
        }
    }
}
