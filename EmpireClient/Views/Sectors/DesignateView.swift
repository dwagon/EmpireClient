//
//  DesignateView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/8/2026.
//

import SwiftUI

struct DesignateView: View {
    var game: Game
    var sector: Sector
    @Binding var viewMode: SectorViewMode

    @State var designation: String = ""

    var body: some View {
        VStack {
            Label(
                "Designate \(sector.coords.toString())",
                systemImage: "pin"
            ).font(.title)
            HStack {
                naturalResourceSection
                designateDetails.padding()
                Spacer()
            }
            HStack {
                CancelButton() {
                    viewMode = .overview
                }
                OkButton("Designate", disabled: designation.isEmpty) {
                    doDesignate(game: game, sector: sector, designation: designation)
                    viewMode = .overview
                }
            }
        }
    }

    var naturalResourceSection: some View {
        Grid {
            GridRow {
                Text("Mine").bold()
                Text("Gold").bold()
                Text("Fertility").bold()
                Text("Oil").bold()
                Text("Uranium").bold()
            }
            Divider()
            GridRow {
                Text(verbatim: "\(sector[.min], default: "?")")
                Text(verbatim: "\(sector[.gold], default: "?")")
                Text(verbatim: "\(sector[.fert], default: "?")")
                Text(verbatim: "\(sector[.ocontent], default: "?")")
                Text(verbatim: "\(sector[.uran], default: "?")")
            }
        }
    }

    var designateDetails: some View {
        return VStack {
            Picker(
                "Select",
                selection: $designation,
                content: {
                    Text("Undefined").tag("")
                    ForEach(DesigType.allCases.sorted(), id: \.self) { des in
                        if Desig(des).isDesignatable {
                            Text(Desig(des).name).tag(Desig(des).abbrev)
                        }
                    }
                }
            )
            .pickerStyle(.menu)
            .padding()
        }
    }

}

func doDesignate(game: Game, sector: Sector, designation: String) {
    Task {
        await game.cmd_designate(
            coord: sector.coords,
            designation: designation
        )
        await game.cmd_dump(sector.coords)
    }
}

