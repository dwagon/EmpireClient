//
//  UnloadView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 4/9/2026.
//

import SwiftUI

struct UnloadShipView: View {
    var shipNum: String
    @Binding var item: Item
    @Binding var amount: Int

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Label("Unload Ship", systemImage: "square.and.arrow.up").font(
                .title
            )
            HStack {
                    ItemPicker(label: "Unload", item: $item)
                    .padding()
                    let str = "Unload \(amount) \(item.displayName.capitalized) from Ship \(shipNum)"
                    Stepper(
                        str,
                        value: $amount,
                        in: 1...1000
                    )
            }
            HStack {
                Button("Cancel", role: .cancel) {
                    amount = 0
                    dismiss()
                }
                .buttonStyle(.automatic)
                .padding()
                Button("Unload") {
                    dismiss()
                }
            }
        }
    }
}

struct UnloadShipSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var shipId: Ship.ID?
    @State private var item: Item = .none
    @State private var amount: Int = 1

    func body(content: Content) -> some View {
        if let shipId {

            content
                .sheet(
                    isPresented: $isPresented
                ) {
                    isPresented = false
                    if amount > 0 {
                        Task {
                            await game.cmd_unload(
                                commodity: item,
                                shipNum: game.ships[shipId]!.number,
                                amount: amount
                            )
                            await game.cmd_ship()
                        }
                    }
                } content: {
                    UnloadShipView(
                        shipNum: game.ships[shipId]!.number,
                        item: $item,
                        amount: $amount
                    )
                }
        }
        else  {
            content
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

#Preview {
    @Previewable @State var item: Item = .none
    @Previewable @State var amount: Int = 1

    UnloadShipView(
        shipNum: "2",
        item: $item,
        amount: $amount,
    )
}

