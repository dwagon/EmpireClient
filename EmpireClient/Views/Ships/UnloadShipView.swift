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
    @Binding var item: Item
    @Binding var amount: Int
    @Binding var selectLand: LandUnit.ID?
    var onButton: () -> Void

    @Environment(\.dismiss) var dismiss

    var availableCargo: [Item] {
        return ship.cargo.keys.filter { ship.cargo[$0]! > 0 }
    }

    var body: some View {
        let landUnits = game.landUnitsAboard(ship)

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
                    ForEach(landUnits) { unit in
                        Text("Nothing").tag(LandUnit.ID?(nil))
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
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .buttonStyle(.automatic)
                .padding()
                Button("Unload") {
                    onButton()
                    dismiss()
                }.disabled(item == .none && selectLand == nil)
            }
        }.padding()
    }
}

struct UnloadShipSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var shipId: Ship.ID?
    @State private var item: Item = .none
    @State private var amount: Int = 1
    @State private var selectLand: LandUnit.ID?

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                if let shipId, let ship = game.ships[shipId] {
                    UnloadShipView(
                        game: game,
                        ship: ship,
                        item: $item,
                        amount: $amount,
                        selectLand: $selectLand
                    ) {
                        if amount > 0 && item != .none {
                            Task {
                                await game.cmd_unload(
                                    commodity: item,
                                    shipNum: ship.number,
                                    amount: amount
                                )
                                await game.cmd_sdump(ship.number)
                                await game.cmd_dump(ship.coords)
                            }
                        }
                        if let selectLand {
                            if let unit = game.landUnits[selectLand] {
                                Task {
                                    await game.cmd_unload(
                                        landUnit: unit,
                                        shipNum: ship.number
                                    )
                                    await game.cmd_sdump(ship.number)
                                    await game.cmd_ldump(unit.number)
                                }
                            }
                        }
                    }
                    .onAppear {
                        item = .none
                        amount = 0
                        selectLand = nil
                    }.task {
                        await game.cmd_ldump()  // So we know about land units at the same location
                    }
                }
            }
    }

}

extension View {
    func unloadShip(
        isPresented: Binding<Bool>,
        game: Game,
        shipId: Ship.ID?
    ) -> some View {
        modifier(
            UnloadShipSheet(
                isPresented: isPresented,
                game: game,
                shipId: shipId
            )
        )
    }
}

//#Preview {
//    @Previewable @State var item: Item = .none
//    @Previewable @State var amount: Int = 1
//    @Previewable @State var ship: Ship = DataLoader.loadSampleShip(
//        name: "ShipView"
//    )
//
//    UnloadShipView(
//        ship: ship,
//        item: $item,
//        amount: $amount,
//    ) {
//        print("Unload \(amount) x \(item) from \(ship)")
//    }
//}
