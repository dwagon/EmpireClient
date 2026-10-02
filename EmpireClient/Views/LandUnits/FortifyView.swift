//
//  FortifyView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 3/10/2026.
//

import SwiftUI

enum FortifyMobilityUse {
    case consume
    case leave
}

struct FortifyView: View {
    var game: Game
    var unit: LandUnit
    @Binding var viewMode: LandViewMode

    @State var mobility: Int = 0
    @State var use: FortifyMobilityUse = .consume

    private var unitLocation: MapCoord? {
        return unit.coords
    }

    var body: some View {
        VStack {
            Label(
                "Fortify Land Unit",
                systemImage: "firewall"
            )
            .font(
                .title
            )
            Text("Current mobility is \(unit.mob). Current fortification is \(unit.fortification)")

            HStack {
                VStack(alignment: .leading) {
                    Text("Mobility:")
                    TextField(
                        "Mobility",
                        value: $mobility,
                        formatter: NumberFormatter()
                    )
                    .textFieldStyle(.roundedBorder)
                    .frame(idealWidth: 100, maxWidth: 150)
                }
                VStack(alignment: .leading) {
                    Picker(selection: $use) {
                        Text("Use \(mobility) mobility to fortify").tag(
                            FortifyMobilityUse.consume
                        )
                        Text("Keep \(mobility) mobility after fortifying").tag(
                            FortifyMobilityUse.leave
                        )
                    } label: {
                        Text("")
                    }
                    .pickerStyle(.radioGroup)
                }
            }.padding()

            HStack {
                CancelButton {
                    viewMode = .overview
                }
                OkButton("Fortify", disabled: mobility == 0) {
                    Task {
                        fortifyUnit(unit: unit, mobility: mobility, mode: use)
                    }
                    viewMode = .overview
                }
            }
        }.padding()
    }

    func fortifyUnit(unit: LandUnit, mobility: Int, mode: FortifyMobilityUse) {
        var mob: Int

        switch mode {
        case .leave:
            mob = -abs(mobility)
        case .consume:
            mob = abs(mobility)
        }
        Task {
            await game.cmd_fortify(unit: unit, mobility: mob)
            await game.cmd_ldump(unit)
        }
    }

}
