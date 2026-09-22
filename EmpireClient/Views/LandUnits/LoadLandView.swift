//
//  LoadLandView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 19/9/2026.
//

import SwiftUI

struct LoadLandView: View {
    var game: Game
    var unitNum: LandNum
    @Binding var item: Item
    @Binding var amount: Int
    var itemList: [Item]
    var onButton: () -> Void

    @Environment(\.dismiss) var dismiss

    var body: some View {
        let unitLocation = game.landUnits[unitNum]?.coords
        let available = game.gameMap[unitLocation!]!.cargo[item]

        VStack {
            Label(
                "Load Land Unit",
                systemImage: "square.and.arrow.down.on.square"
            )
            .font(
                .title
            )
            HStack {
                ItemPicker(label: "Load what item?", itemList: itemList, item: $item).padding()
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
                    : "Load \(amount) \(item.displayName.capitalized) (\(available, default: "None") avail) onto Unit \(unitNum)"
            )
            HStack {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .padding()
                Button("Load") {
                    dismiss()
                    onButton()
                }.disabled(item == .none)
            }
            .buttonStyle(.automatic)
        }.padding()
    }
}

struct LoadLandUnitSheet: ViewModifier {
    @Binding var isPresented: Bool
    @State var item: Item = .none
    @State var amount: Int = 0
    var game: Game
    var unitId: LandUnit.ID?
    private var itemList: [Item]

    init(isPresented: Binding<Bool>, game: Game, unitId: LandUnit.ID?) {
        self._isPresented = isPresented
        self.game = game
        self.unitId = unitId
        self.itemList = []

        if let unitId {
            if let unitLocation = game.landUnits[unitId]?.coords {
                if let sector = game.gameMap[unitLocation] {
                    let available = sector.cargo.filter({
                        $0.value > 0
                    })
                    var items = Array(available.keys)
                    items.insert(.none, at: 0)
                    self.itemList = items
                }
            }
        }
    }
    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                if let unitId {
                    LoadLandView(
                        game: game,
                        unitNum: game.landUnits[unitId]!.number,
                        item: $item,
                        amount: $amount,
                        itemList: itemList
                    ) {
                        if let unit = game.landUnits[unitId] {
                            Task {
                                await game.cmd_lload(commodity: item, unit: unit, amount: amount)
                                await game.cmd_ldump(unit)
                                await game.cmd_dump(unit.coords)
                            }
                        }
                    }
                    .onAppear {
                        item = .none
                        amount = 0
                    }
                }
            }
    }
}

extension View {
    func loadLandUnit(
        isPresented: Binding<Bool>,
        game: Game,
        unitId: LandUnit.ID?
    ) -> some View {
        modifier(
            LoadLandUnitSheet(
                isPresented: isPresented,
                game: game,
                unitId: unitId
            )
        )
    }
}


#Preview {
    @Previewable @State var game: Game = Game()
    @Previewable @State var item: Item = .none
    @Previewable @State var amount: Int = 1

    LoadLandView(
        game: game,
        unitNum: 2,
        item: $item,
        amount: $amount,
        itemList: [.civ, .mil, .food]
    ) {
        print("Loaded \(amount) x \(item)")
    }
}
