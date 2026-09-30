//
//  TendShipView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/9/2026.
//

import SwiftUI

struct TendShipView: View {
    var game: Game
    var ship: Ship
    @Binding var viewMode: ShipViewMode
    @State private var commodity: Item = .none
    @State private var toShipId: Ship.ID?
    @State private var amount: Int = 0

    var availableCargo: [Item] {
        return ship.cargo.keys.filter { ship.cargo[$0]! > 0 }
    }

    private var otherShipsAtLocation: [Ship] {
        return game.shipsAt(ship.coords).filter({ $0.id != ship.id })
    }

    private var otherShip: Ship? {
        guard let toShipId, let toShip = game.ships[toShipId] else {
            return nil
        }
        return toShip
    }

    var body: some View {
        VStack {
            Label(
                "Tend From Ship \(ship.number) \(ship.name)",
                systemImage: "rectangle.2.swap"
            )
            .font(
                .title
            )
            if otherShipsAtLocation.isEmpty {
                    Text("No other ship to tend to at this location").foregroundStyle(.red).bold()
            } else {
                HStack {
                    ItemPicker(
                        label: "Tend",
                        itemList: availableCargo,
                        item: $commodity
                    )
                    .padding()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Transfer:")
                            TextField(
                                "Amount",
                                value: $amount,
                                formatter: NumberFormatter()
                            )
                            .textFieldStyle(.roundedBorder)
                            .frame(idealWidth: 100, maxWidth: 150)
                        }
                    }
                    if !otherShipsAtLocation.isEmpty {
                        Picker("to", selection: $toShipId) {
                            ForEach(otherShipsAtLocation) { other in
                                Text(
                                    "Ship \(other.number) \(other.name): \(other.abbrev)"
                                ).tag(other.id)
                            }
                        }.pickerStyle(.radioGroup)
                    }


                }
            }
            HStack {
                if let available = ship.cargo[commodity] {
                    Text(
                        "Tend \(amount) \(commodity.displayName.capitalized) (\(available) avail)"
                    )
                }
                if let otherShip {
                    Text(
                        "onto Ship \(otherShip.number) \(otherShip.name)"
                    )
                }
            }
            HStack {
                CancelButton {
                    viewMode = .overview
                }
                OkButton(
                    "Tend",
                    disabled: commodity == .none || amount <= 0
                        || toShipId == nil
                ) {
                    Task {
                        await tendShip()
                        viewMode = .overview
                    }
                }
            }
        }.padding()
    }

    func tendShip() async {
        guard let toShipId, let toShip = game.ships[toShipId] else { return }
        await game.cmd_tend(
            commodity: commodity,
            fromShip: ship,
            amount: amount,
            toShip: toShip
        )
        await game.cmd_sdump(ship)
        await game.cmd_sdump(toShip)
    }
}
