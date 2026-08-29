//
//  ItemPicker.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/8/2026.
//

import SwiftUI

struct ItemPicker: View {
    var label: String
    @Binding var item: Item

    var body: some View {
        Picker(
            label,
            selection: $item,
            content: {
                ForEach(Item.allCases, id: \.self) { item in
                    Text(item.displayName.capitalized).tag(item)
                }
            }
        )
        .pickerStyle(.menu)
    }
}

#Preview {
    @Previewable @State var item: Item = .none
    ItemPicker(label: "Do something", item: $item)
}
