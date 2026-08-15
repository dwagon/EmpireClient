//
//  DesignateView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/8/2026.
//

import SwiftUI

struct DesignateView: View {
    var sector: Sector
    @Binding var designation: String

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Label("Designate \(sector.coords.x), \(sector.coords.y)", systemImage: "pin").font(.title)
            HStack {
                naturalResourceSection
                DesignateDetails.padding()
                Spacer()
            }
            HStack {
                Button("Designate") {
                    dismiss()
                }
                .buttonStyle(.automatic)
                .padding()
                Button("Cancel", role: .cancel) {
                    designation = ""
                    dismiss()
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

    var DesignateDetails: some View {
        return VStack {
            Picker(
                "Select",
                selection: $designation,
                content: {
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

#Preview {
    @Previewable @State var sector = Sector(coords: MapCoord(x: 0, y: 0))
    @Previewable @State var designation: String = ""

    DesignateView(
        sector: sector,
        designation: $designation
    )
}
