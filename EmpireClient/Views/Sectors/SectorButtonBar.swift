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
            backButton
            refreshButton
            buildButton
            thresholdButton
            distributeButton
            exploreButton
            designateButton
            moveButton
            optimizeButton
        }
    }

    var backButton: some View {
        return Button("Back") {
            viewMode = .overview
        }.disabled(viewMode == .overview)
    }

    var buildButton: some View {
        return Button("Build") {
            viewMode = .build
        }.disabled(buildDisabled)
    }

    var thresholdButton: some View {
        return Button("Threshold") {
            viewMode = .threshold
        }
    }

    var distributeButton: some View {
        return Button("Distribute") {
            viewMode = .distribute
        }
    }

    var exploreButton: some View {
        return Button("Explore") {
            viewMode = .explore
        }
    }

    var designateButton: some View {
        return Button("Designate") {
            viewMode = .designate
        }
    }

    var optimizeButton: some View {
        return Button("Optimize") {
            viewMode = .optimize
        }
    }

    var moveButton: some View {
        return Button("Move") {
            viewMode = .move
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

    var buildDisabled: Bool {
        guard let sector else {
            return true
        }
        if sector.coast {
            return false
        }
        switch sector.desig.desig {
        case .harbor:
            return false
        case .airfield:
            return false
        case .headquarters:
            return false
        case .nuclearPlant:
            return false
        default:
            return true
        }
    }
}
