//
//  RawCmdView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 18/8/2026.
//

import SwiftUI

struct RawCmdView: View {
    var game: Game
    @State var cmd_string: String = ""

    var body: some View {
        TextField("Command", text: $cmd_string)
            .disableAutocorrection(true)
            .font(.system(.body, design: .monospaced))
            .frame(maxWidth: 8*80)
            .onSubmit {
                Task {
                    await game.cmd_raw(cmd_string)
                }
            }
    }
}

#Preview {
    @Previewable @State var game = Game()
    RawCmdView(game: game)
}
