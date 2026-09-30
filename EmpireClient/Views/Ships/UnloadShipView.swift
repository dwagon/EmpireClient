//
//  UnloadView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 4/9/2026.
//

import SwiftUI

struct UnloadShipView: View {
    var game: Game
    var ship: Ship
    @Binding var viewMode: ShipViewMode
    @State var item: Item = .none
    @State var amount: Int = 0
    @State var selectLand: LandUnit.ID?

    var availableCargo: [Item] {
        return ship.cargo.keys.filter { ship.cargo[$0]! > 0 }
    }

    var landUnits: [LandUnit] {
        return game.landUnitsAboard(ship)
    }

    var body: some View {
        VStack {
            Label(
                "Unload Ship \(ship.number) \(ship.name)",
                systemImage: "square.and.arrow.up"
            ).font(
                .title
            )
            HStack {
                ItemPicker(
                    label: "Unload",
                    itemList: availableCargo,
                    item: $item
                )
                .padding()
                VStack(alignment: .leading) {
                    HStack {
                        Text("Amount:")
                        TextField(
                            "Unload Amount",
                            value: $amount,
                            formatter: NumberFormatter()
                        )
                        .textFieldStyle(.roundedBorder)
                        .frame(idealWidth: 100, maxWidth: 150)
                    }
                }
            }
            if !landUnits.isEmpty {
                Divider()
                Picker("Unload land unit", selection: $selectLand) {
                    Text("Nothing").tag(LandUnit.ID?(nil))
                    ForEach(landUnits) { unit in
                        Text("Unit \(unit.number): \(unit.abbrev)").tag(unit.id)
                    }.pickerStyle(.radioGroup)
                }
            }
            Text(
                item == .none
                    ? ""
                    : "Unload \(amount) of \(ship.cargo[item]!) \(item.displayName.capitalized)"
            )
            HStack {
                CancelButton {
                    viewMode = .overview
                }
                OkButton(
                    "Unload",
                    disabled: (item == .none || amount <= 0)
                        && selectLand == nil
                ) {
                    Task {
                        await unloadShip()
                    }
                    viewMode = .overview
                }
            }
        }.padding()
    }

    func unloadShip() async {
        if amount > 0 && item != .none {
            await game.cmd_unload(
                commodity: item,
                ship: ship,
                amount: amount
            )
            await game.cmd_sdump(ship)
            await game.cmd_dump(ship.coords)
        }
        if let selectLand {
            if let unit = game.landUnits[selectLand] {
                await game.cmd_unload(
                    landUnit: unit,
                    ship: ship
                )
                await game.cmd_sdump(ship)
                await game.cmd_ldump(unit)
            }
        }
    }
}
