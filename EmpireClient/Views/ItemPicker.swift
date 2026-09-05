//
//  ItemPicker.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/8/2026.
//  Pick from the various items

import SwiftUI

struct ItemPicker: View {
    var label: String
    var itemList: [Item]
    @Binding var item: Item

    init(label: String, itemList: [Item], item: Binding<Item>) {
        self.label = label
        self.itemList = itemList
        _item = item
    }

    init(label: String, item: Binding<Item>) {
        self.label = label
        _item = item
        self.itemList = Item.allCases
    }

    var body: some View {
        Picker(
            label,
            selection: $item,
            content: {
                ForEach(itemList, id: \.self) { item in
                    Text(item.displayName.capitalized).tag(item)
                }
            }
        )
        .pickerStyle(.menu)
        .padding()
    }
}

#Preview {
    @Previewable @State var item: Item = .none
    ItemPicker(label: "Do something", item: $item)
}

#Preview("Subset") {
    @Previewable @State var item: Item = .none
    ItemPicker(
        label: "Do something",
        itemList: [Item.civ, Item.mil],
        item: $item
    )
}
