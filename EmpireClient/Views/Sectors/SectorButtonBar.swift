//
//  SectorButtonBar.swift
//  EmpireClient
//
//  Created by Dougal Scott on 7/10/2026.
//

import SwiftUI

struct SectorButtonBar: View {
    var game: Game
    var sector: Sector?
    @Binding var viewMode: SectorViewMode

    var body: some View {
        VStack {
            refreshButton
        }
    }

    var refreshButton: some View {
        return Button("Refresh") {
            Task {
                await game.cmd_map()
                await game.cmd_ldump()
            }
        }
    }
}
