//
//  TabbedView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 28/9/2026.
//

import SwiftUI

enum TabChosen: Equatable, Hashable {
    case sector
    case ship
    case plane
    case land
    case nuke
}

struct TabbedDetailView: View {
    var game: Game
    @Binding var selectedTab: TabChosen
    @Binding var centerCoord: MapCoord
    @Binding var sectorSelect: Bool

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Sectors", systemImage: "info", value: .sector) {
                SectorOverView(game: game, centerCoord: $centerCoord)
            }
            Tab("Ships", systemImage: "sailboat", value: .ship) {
                ShipOverView(
                    game: game,
                    centerCoord: $centerCoord,
                    sectorSelect: $sectorSelect
                )
            }.disabled(game.ships.isEmpty)
            Tab(
                "Land Units",
                systemImage: "car.rear.road.lane.distance.5",
                value: .land
            ) {
                LandOverView(
                    game: game,
                    centerCoord: $centerCoord,
                    sectorSelect: $sectorSelect
                )
            }.disabled(game.landUnits.isEmpty)
            Tab("Planes", systemImage: "airplane.up.right", value: .plane) {
                PlaneOverView(
                    game: game,
                    centerCoord: $centerCoord,
                    sectorSelect: $sectorSelect
                )
            }.disabled(game.planes.isEmpty)
            Tab(
                "Nukes",
                systemImage: "sun.max.trianglebadge.exclamationmark",
                value: .nuke
            ) {
                NukeDetailView(game: game, centerCoord: $centerCoord)
            }.disabled(game.nukes.isEmpty)
        }
        .onChange(of: selectedTab) { _, newTab in
            switch newTab {
            case .land:
                Task {
                    await game.cmd_ldump()
                }
            case .ship:
                Task {
                    await game.cmd_sdump()
                }
            case .plane:
                Task {
                    await game.cmd_pdump()
                }
            case .nuke:
                Task {
                    await game.cmd_ndump()
                }
            case .sector:
                break
            }
        }
    }
}
