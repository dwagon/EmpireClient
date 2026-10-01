//
//  LoadLandView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 19/9/2026.
//

import SwiftUI

struct LandLoadView: View {
    var game: Game
    var unit: LandUnit
    @Binding var viewMode: LandViewMode

    @State var item: Item = .none
    @State var amount: Int = 0

    var itemList: [Item] {
        guard let location = unitLocation, let sector = game.gameMap[location]
        else { return [.none] }
        return [.none] + sector.cargo.filter { $0.value > 0 }.map(\.key)
    }

    private var itemAvailable: Int? {
        guard item != .none,
            let unitLocation,
            let sector = game.gameMap[unitLocation]
        else {
            return nil
        }
        return sector.cargo[item]
    }

    private var unitLocation: MapCoord? {
        return unit.coords
    }

    var body: some View {
        VStack {
            Label(
                "Load Land Unit",
                systemImage: "square.and.arrow.down.on.square"
            )
            .font(
                .title
            )
            HStack {
                ItemPicker(
                    label: "Load what item?",
                    itemList: itemList,
                    item: $item
                ).padding()
                VStack(alignment: .leading) {
                    Text("Amount:")
                    TextField(
                        "Load Amount",
                        value: $amount,
                        formatter: NumberFormatter()
                    )
                    .textFieldStyle(.roundedBorder)
                    .frame(idealWidth: 100, maxWidth: 150)
                }
            }.padding()
            Text(
                item == .none
                    ? ""
                    : "Load \(amount) \(item.displayName.capitalized) (\(itemAvailable, default: "None") avail) onto Unit \(unit.number)"
            )
            HStack {
                CancelButton {
                    viewMode = .overview
                }
                OkButton("Load", disabled: (item == .none || amount <= 0)) {
                    Task {
                        loadLand(unit: unit, item: item, amount: amount)
                    }
                    viewMode = .overview
                }
            }
        }.padding()
    }

    func loadLand(unit: LandUnit, item: Item, amount: Int) {
        Task {
            await game.cmd_lload(
                commodity: item,
                unit: unit,
                amount: amount
            )
            await game.cmd_ldump(unit)
            await game.cmd_dump(unit.coords)
        }
    }

}
