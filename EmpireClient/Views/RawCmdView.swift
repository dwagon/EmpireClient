//
//  RawCmdView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 18/8/2026.
//

import SwiftUI

struct RawCmdView: View {
    var game: Game
    @State var cmdString: String = ""

    var body: some View {
        TextField("Command", text: $cmdString)
            .disableAutocorrection(true)
            .font(.system(.body, design: .monospaced))
            .frame(maxWidth: 8*80)
            .onSubmit {
                Task {
                    await game.cmd_raw(cmdString)
                }
            }
    }
}

#Preview {
    @Previewable @State var game = Game()
    RawCmdView(game: game)
}
