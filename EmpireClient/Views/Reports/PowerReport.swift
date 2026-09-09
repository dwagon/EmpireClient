//
//  PowerReport.swift
//  EmpireClient
//
//  Created by Dougal Scott on 9/9/2026.
//

import SwiftUI

struct PowerReport: View {
    let game: Game
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            VStack {
                if game.powerReport.isEmpty {
                    EmptyView()
                } else {
                    Text(game.powerReport[0..<3].joined(separator: "\n"))
                        .multilineTextAlignment(.center)
                    Text(game.powerReport[3...].joined(separator: "\n"))
                        .multilineTextAlignment(.trailing)
                }
            }
            .font(
                .system(.body, design: .monospaced)
            ).border(.blue)
            .task { await game.cmd_power() }
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
    PowerReport(game: game)
}
