//
//  MoveView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 7/10/2026.
//

import SwiftUI

struct MoveView: View {
    var game: Game
    var sector: Sector
    @Binding var destination: MapCoord
    @Binding var sectorSelect: Bool
    @Binding var viewMode: SectorViewMode

    @State var item: Item
    @State var amount: Int
    @State var origLocation: MapCoord

    init(
        game: Game,
        sector: Sector,
        destination: Binding<MapCoord>,
        sectorSelect: Binding<Bool>,
        viewMode: Binding<SectorViewMode>,
    ) {
        self.game = game
        self.sector = sector
        self._destination = destination
        self._viewMode = viewMode
        self._sectorSelect = sectorSelect
        self.item = .mil
        self.amount = 1
        self._origLocation = State(initialValue: destination.wrappedValue)
    }

    private var itemList: [Item] {
        return [.none] + sector.cargo.filter { $0.value > 0 }.map(\.key)
    }

    private var itemAvailable: Int? {
        return sector.cargo[item]
    }

    var body: some View {
        VStack {
            Label(
                "Move commodity",
                systemImage: "arrowshape.left.arrowshape.right"
            ).font(.title)
            moveDetails.padding()

            HStack {
                CancelButton {
                    viewMode = .overview
                    sectorSelect = true
                    destination = origLocation
                }
                OkButton(
                    "Move",
                    disabled: destination == origLocation || amount == 0
                ) {
                    doMove(
                        game: game,
                        item: item,
                        centerCoord: origLocation,
                        number: amount,
                        destination: destination
                    )
                    viewMode = .overview
                    sectorSelect = true
                }
            }
        }
        .onAppear {
            sectorSelect = false
            origLocation = destination
        }
    }

    var moveDetails: some View {
        return VStack {
            ItemPicker(label: "Commodity", itemList: itemList, item: $item)
                .padding()
            HStack {
                Text("Amount:")
                TextField(
                    "Move Amount",
                    value: $amount,
                    formatter: NumberFormatter()
                )
                .textFieldStyle(.roundedBorder)
                .frame(idealWidth: 100, maxWidth: 150)
            }
            Text("Move \(amount) of \(itemAvailable, default: "?") \(item.displayName) to \(destination.toString())").padding()
        }
    }
}

func doMove(
    game: Game,
    item: Item,
    centerCoord: MapCoord,
    number: Int,
    destination: MapCoord
) {
    Task {
        await game.cmd_move(
            item: item,
            sect: centerCoord,
            number: number,
            destination: destination
        )
        await game.cmd_dump(centerCoord)
        await game.cmd_dump(destination)
    }
}
