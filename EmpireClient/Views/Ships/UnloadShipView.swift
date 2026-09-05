//
//  UnloadView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 4/9/2026.
//

import SwiftUI

struct UnloadShipView: View {
    var ship: Ship
    @Binding var item: Item
    @Binding var amount: Int

    @Environment(\.dismiss) var dismiss

    var availableCargo: [Item] {
        return ship.cargo.keys.filter { ship.cargo[$0]! > 0 }
    }

    var body: some View {
        VStack {
            Label(
                "Unload Ship \(ship.number)",
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
            Text(item == .none ? "" : "Unload \(amount) \(item.displayName.capitalized)")
            HStack {
                Button("Cancel", role: .cancel) {
                    amount = 0
                    dismiss()
                }
                .buttonStyle(.automatic)
                .padding()
                Button("Unload") {
                    dismiss()
                }.disabled(item == .none)
            }
        }.padding()
    }
}

struct UnloadShipSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var ship: Ship?
    @State private var item: Item = .none
    @State private var amount: Int = 1

    func body(content: Content) -> some View {
        if let ship {
            content
                .sheet(
                    isPresented: $isPresented
                ) {
                    isPresented = false
                    if amount > 0 {
                        Task {
                            await game.cmd_unload(
                                commodity: item,
                                shipNum: ship.number,
                                amount: amount
                            )
                            await game.cmd_ship()
                            amount = 0
                            item = .none
                        }
                    }
                } content: {
                    UnloadShipView(
                        ship: ship,
                        item: $item,
                        amount: $amount
                    )
                }
        } else {
            content
        }
    }
}

extension View {
    func unloadShip(
        isPresented: Binding<Bool>,
        game: Game,
        ship: Ship?
    ) -> some View {
        modifier(
            UnloadShipSheet(
                isPresented: isPresented,
                game: game,
                ship: ship
            )
        )
    }
}

#Preview {
    @Previewable @State var item: Item = .none
    @Previewable @State var amount: Int = 1
    @Previewable @State var ship: Ship = DataLoader.loadSampleShip(
        name: "ShipView"
    )

    UnloadShipView(
        ship: ship,
        item: $item,
        amount: $amount,
    )
}
