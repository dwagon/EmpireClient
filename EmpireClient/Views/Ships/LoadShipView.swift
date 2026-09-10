//
//  LoadView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/8/2026.
//

import SwiftUI

struct LoadShipView: View {
    var game: Game
    var shipNum: String
    @Binding var item: Item
    @Binding var amount: Int
    var itemList: [Item]

    @Environment(\.dismiss) var dismiss

    var body: some View {
        let shipLocation = game.ships[shipNum]?.coords
        let available = game.gameMap[shipLocation!]!.cargo[item]

        VStack {
            Label("Load Ship \(shipNum)", systemImage: "square.and.arrow.down")
                .font(
                    .title
                )
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
            Text(
                item == .none
                    ? ""
                : "Load \(amount) \(item.displayName.capitalized) (\(available, default: "None") avail) onto Ship \(shipNum)"
            )
            HStack {
                Button("Cancel", role: .cancel) {
                    amount = 0
                    dismiss()
                }
                .buttonStyle(.automatic)
                .padding()
                Button("Load") {
                    dismiss()
                }.disabled(item == .none)
            }
        }
    }
}

struct LoadShipSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var shipId: Ship.ID?
    @State private var item: Item = .none
    @State private var amount: Int = 1
    private var itemList: [Item]

    init(isPresented: Binding<Bool>, game: Game, shipId: Ship.ID?) {
        self._isPresented = isPresented
        self.game = game
        self.shipId = shipId
        self.itemList = []

        if let shipId {
            if let shipLocation = game.ships[shipId]?.coords {
                let available = game.gameMap[shipLocation]!.cargo.filter({
                    $0.value > 0
                })
                var items = Array(available.keys)
                items.insert(.none, at: 0)
                self.itemList = items
            }
        }
    }

    func body(content: Content) -> some View {
        if let shipId {
            content
                .sheet(
                    isPresented: $isPresented
                ) {
                    isPresented = false
                    if amount > 0 {
                        Task {
                            await game.cmd_load(
                                commodity: item,
                                shipNum: game.ships[shipId]!.number,
                                amount: amount
                            )
                            await game.cmd_ship()
                            amount = 0
                            item = .none
                        }
                    }
                } content: {
                    LoadShipView(
                        game: game,
                        shipNum: game.ships[shipId]!.number,
                        item: $item,
                        amount: $amount,
                        itemList: itemList
                    )
                }
        } else {
            content
        }
    }
}

extension View {
    func loadShip(
        isPresented: Binding<Bool>,
        game: Game,
        shipId: Ship.ID?
    ) -> some View {
        modifier(
            LoadShipSheet(
                isPresented: isPresented,
                game: game,
                shipId: shipId
            )
        )
    }
}

#Preview {
    @Previewable @State var game: Game = Game()
    @Previewable @State var item: Item = .none
    @Previewable @State var amount: Int = 1

    LoadShipView(
        game: game,
        shipNum: "2",
        item: $item,
        amount: $amount,
        itemList: [.civ, .mil]
    )
}
