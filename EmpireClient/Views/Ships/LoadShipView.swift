//
//  LoadView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/8/2026.
//

import SwiftUI

struct LoadShipView: View {
    var game: Game
    var selectedShip: Ship.ID?
    @Binding var viewMode: ShipViewMode

    @State var item: Item = .none  // Item to load
    @State var amount: Int = 0  // Amount of {item} to load
    @State var selectLand: LandUnit.ID?  // Land unit selected to load

    private var itemList: [Item] {
        guard let location = shipLocation,
            let sector = game.gameMap[location]
        else {
            return [.none]
        }
        return [.none] + sector.cargo.filter { $0.value > 0 }.map(\.key)
    }

    private var itemAvailable: Int? {
        guard item != .none,
            let location = shipLocation,
            let sector = game.gameMap[location]
        else {
            return nil
        }
        return sector.cargo[item]
    }

    private var landUnits: [LandUnit] {
        guard let location = shipLocation
        else {
            return []
        }
        return game.landUnitsAt(location)
    }

    private var shipLocation: MapCoord? {
        guard let selectedShip,
              let location = game.ships[selectedShip]?.coords
        else {
            return nil
        }

        return location
    }

    var body: some View {
        VStack {
            Label(
                "Load Ship \(selectedShip, default: "")",
                systemImage: "square.and.arrow.down"
            )
            .font(
                .title
            )
            ShipDetailView(game: game, selectedShip: selectedShip)
            HStack {
                ItemPicker(label: "Load", itemList: itemList, item: $item)
                    .padding()
                VStack(alignment: .leading) {
                    HStack {
                        Text("Amount:")
                        TextField(
                            "Load Amount",
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
                Picker("Load Land Unit", selection: $selectLand) {
                    Text("Nothing").tag(LandUnit.ID?.none)
                    ForEach(landUnits) { unit in
                        Text("Unit \(unit.number): \(unit.abbrev)").tag(unit.id)
                    }
                }.pickerStyle(.radioGroup)
            }

            Text(
                item == .none
                    ? ""
                    : "Load \(amount) \(item.displayName.capitalized) (\(itemAvailable, default: "None") avail) onto Ship \(selectedShip, default: "")"
            )
            Text(
                selectLand == nil
                    ? "" : "Load Land Unit \(selectLand, default: "unknown")"
            )
            HStack {
                CancelButton("Cancel") {
                    viewMode = .overview
                }
                OkButton("Load", disabled: ((item == .none && amount <= 0) && selectLand == nil)) {
                    Task {
                        await loadShip(
                            selectedShip: selectedShip,
                            amount: amount,
                            selectLand: selectLand,
                            item: item
                        )
                    }
                    viewMode = .overview
                }
            }
        }
    }

    func loadShip(
        selectedShip: Ship.ID?,
        amount: Int,
        selectLand: LandUnit.ID?,
        item: Item
    ) async {
        if let selectedShip, let ship = game.ships[selectedShip] {
            if amount > 0 {
                Task {
                    await game.cmd_load(
                        commodity: item,
                        ship: ship,
                        amount: amount
                    )
                    await game.cmd_sdump(ship)
                    await game.cmd_dump(ship.coords)
                }
            }
            if let selectLand {
                if let unit = game.landUnits[selectLand] {
                    Task {
                        await game.cmd_load(
                            landUnit: unit,
                            ship: ship
                        )
                        await game.cmd_ldump(unit)
                        await game.cmd_sdump(ship)
                    }
                }
            }
        }
    }
}
