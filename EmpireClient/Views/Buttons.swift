//
//  Buttons.swift
//  EmpireClient
//
//  Created by Dougal Scott on 25/9/2026.
//

import SwiftUI

struct CancelButton: View {
    var action: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button("Cancel", role: .cancel) {
            action?()
            dismiss()
        }.keyboardShortcut(.escape)
            .buttonStyle(.automatic)
            .padding()
    }
}

struct OkButton: View {
    var label: String
    var disabled: Bool
    var action: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss

    init(
        _ label: String = "OK",
        disabled: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.label = label
        self.disabled = disabled
        self.action = action
    }

    var body: some View {
        Button(label, role: .confirm) {
            action?()
            dismiss()
        }.keyboardShortcut(.defaultAction)
            .buttonStyle(.automatic)
            .padding()
            .disabled(disabled)
    }
}

#Preview {
    CancelButton()
    OkButton("Do It")
}
