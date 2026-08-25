//
//  BudgetReportView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/8/2026.
//

import SwiftUI

struct BudgetReport: View {
    let game: Game
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text(game.budget_report.joined(separator: "\n"))
                .font(
                    .system(.body, design: .monospaced)
                ).border(.blue)
            HStack {
                Button("OK") {
                    dismiss()
                }
            }
        }

    }
}

#Preview {
    @Previewable @State var game: Game = Game()
    BudgetReport(game: game)
}
