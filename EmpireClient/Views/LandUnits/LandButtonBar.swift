//
//  LandButtonBar.swift
//  EmpireClient
//
//  Created by Dougal Scott on 30/9/2026.
//

import SwiftUI

struct LandButtonBar: View {
    var game: Game
    @Binding var selectedUnit: LandUnit.ID?
    @Binding var viewMode: LandViewMode

    var body: some View {
        VStack {
            refreshButton

            if selectedUnit != nil {
                if viewMode != .overview {
                    backButton
                }
                loadButton
                marchButton
            }
        }
    }

    var backButton: some View {
        return Button("Back") {
            viewMode = .overview
        }
    }

    var refreshButton: some View {
        return
            Button("Refresh") {
                Task {
                    await game.cmd_map()
                    await game.cmd_ldump()
                }
            }
    }

    var loadButton: some View {
        return
            Button("Load") {
                viewMode = .load
            }
    }

    var marchButton: some View {
        return
            Button("March") {
                viewMode = .march
            }
    }
}
