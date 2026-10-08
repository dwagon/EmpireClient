//
//  ExploreView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 11/8/2026.
//

import HexGrid
import SwiftUI

struct ExploreView: View {
    var game: Game
    var sector: Sector
    @Binding var destination: MapCoord
    @Binding var sectorSelect: Bool
    @Binding var viewMode: SectorViewMode

    @State var item: Item
    @State var number: Int
    @State var origLocation: MapCoord
    @State var destinationCell: Cell?
    @State var error: String = ""
    @State var destStr: String?

    init(
        game: Game,
        sector: Sector,
        destination: Binding<MapCoord>,
        sectorSelect: Binding<Bool>,
        viewMode: Binding<SectorViewMode>
    ) {
        self.game = game
        self.sector = sector
        self._destination = destination
        self._sectorSelect = sectorSelect
        self._viewMode = viewMode
        self._origLocation = State(initialValue: destination.wrappedValue)
        self.item = .mil
        self.number = 1
    }

    var body: some View {
        VStack {
            Label("Explore new territory", systemImage: "map.fill").font(.title)
            exploreDetails.padding()
            HStack {
                CancelButton {
                    viewMode = .overview
                    sectorSelect = true
                }
                OkButton(
                    "Explore to \(destination.toString())",
                    disabled: destination == origLocation || number == 0 || destStr == nil
                ) {
                    if let destStr {
                        doExplore(
                            game: game,
                            item: item,
                            centerCoord: sector.coords,
                            number: number,
                            destination: destStr
                        )
                        viewMode = .overview
                        sectorSelect = true
                    }
                }
            }
        }
        .padding()
        .onAppear {
            sectorSelect = false
            origLocation = destination
        }
        .onChange(of: destination) {
            destStr = directionString(destination - origLocation)
            if destStr == nil {
               error = "Can only explore to adjacent hex"
           }
        }
    }

    var exploreDetails: some View {
        return VStack {
            Picker(
                "Use",
                selection: $item,
                content: {
                    Text("Military (\(sector.cargo[.mil] ?? 0))").tag(
                        Item.mil
                    )
                    Text("Civilians (\(sector.cargo[.civ] ?? 0))").tag(
                        Item.civ
                    )
                }
            )
            .pickerStyle(.inline)
            .padding()

            Stepper(
                "Send \(number) "
                    + ((item == Item.mil) ? "military" : "civilians"),
                value: $number,
                in: 1...max(1, sector.cargo[item] ?? 1)
            )
            if !error.isEmpty {
                Text(error).foregroundStyle(.red)
            }
        }
    }
}

func doExplore(
    game: Game,
    item: Item,
    centerCoord: MapCoord,
    number: Int,
    destination: String
) {
    Task {
        await game.cmd_explo(
            item: item,
            sector: centerCoord,
            number: number,
            destination: destination
        )
        await game.cmd_dump()
        await game.cmd_map()
    }
}
