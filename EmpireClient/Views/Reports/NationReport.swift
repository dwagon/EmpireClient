//
//  NationReportView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/8/2026.
//

import SwiftUI

struct NationReport: View {
    let game: Game
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text(game.nation_report.joined(separator: "\n"))
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
    NationReport(game: game)
}
