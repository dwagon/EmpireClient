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
                Button("Cancel") {
                    viewMode = .overview
                    destination = origLocation
                }
                Button("March") {
                    marchToLocation(destination, unit: unit)
                    viewMode = .overview
                }.disabled(destination == origLocation)
            }
        }.padding()
            .onAppear {
                origLocation = destination
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
