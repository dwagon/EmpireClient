//
//  MarchView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/9/2026.
//

import SwiftUI

struct MarchView: View {
    var game: Game
    var unit: LandUnit
    @Binding var destination: MapCoord
    @Binding var viewMode: LandViewMode
    @Binding var sectorSelect: Bool

    @State var origLocation: MapCoord = MapCoord(x: 0, y: 0)

    var body: some View {
        VStack {
            Label(
                "March \(unit.number) \(unit.abbrev)",
                systemImage: "figure.walk"
            )
            .font(
                .title
            )
            HStack {
                CancelButton() {
                    viewMode = .overview
                    destination = origLocation
                    sectorSelect = true
                }
                OkButton("March to \(destination.toString())", disabled: destination == origLocation) {
                    marchToLocation(destination, unit: unit)
                    viewMode = .overview
                    sectorSelect = true
                }
            }
        }.padding()
            .onAppear {
                origLocation = destination
                sectorSelect = false
            }
    }

    func marchToLocation(_ destination: MapCoord, unit: LandUnit) {
        Task {
            await game.cmd_march(
                unit: unit,
                destination: destination
            )
            await game.cmd_ldump(unit)
            await game.cmd_map(cmdArg: String(unit.number))
        }
    }

}
