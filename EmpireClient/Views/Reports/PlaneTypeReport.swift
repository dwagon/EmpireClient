//
//  PlaneTypeReport.swift
//  EmpireClient
//
//  Created by Dougal Scott on 13/9/2026.
//

import SwiftUI

struct PlaneTypeReport: View {
    let planeTypes: [PlaneType]
    let currTech: Float

    @Environment(\.dismiss) private var dismiss
    @State private var selectedUnit: PlaneType.ID?

    var body: some View {
        VStack {
            Table(planeTypes, selection: $selectedUnit) {
                TableColumn("Abbrev") { details in
                    Text("\(details.abbrev)").buildableHighlight(
                        details.isBuildable(techlevel: currTech)
                    )

                }.width(min: 30, ideal: 50, max: 60)

                TableColumn("Name") { details in
                    Text("\(details.name)").buildableHighlight(
                        details.isBuildable(techlevel: currTech)
                    )
                }
                .width(min: 60, ideal: 100, max: 120)

                TableColumn("Tech") { details in
                    Text("\(details.tech)").buildableHighlight(
                        details.isBuildable(techlevel: currTech)
                    )

                }
                .width(min: 60, ideal: 100, max: 120)

                TableColumn("Capabilities") { details in
                    Text("\(details.capabilities)").buildableHighlight(
                        details.isBuildable(techlevel: currTech)
                    )

                }
            }
            .tableStyle(.bordered)
            .border(.blue)
            if let selectedUnit {
                Spacer()
                if let plane = planeTypes.first(where: { $0.id == selectedUnit }
                ) {
                    PlaneTypeView(planeType: plane)
                        .border(.blue).padding()
                }
            }
            HStack {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }

    struct PlaneTypeView: View {
        let planeType: PlaneType

        var body: some View {
            HStack(alignment: .top) {
                Grid(alignment: .leading) {
                    GridRow {
                        Text("Build Costs")
                            .gridCellColumns(2)
                            .bold()
                    }
                    GridRow {
                        Text("LCM")
                        Text("\(planeType.lcmCost)")
                    }
                    GridRow {
                        Text("HCM")
                        Text("\(planeType.hcmCost)")
                    }
                    GridRow {
                        Text("Crew")
                        Text("\(planeType.crewCost)")
                    }
                    GridRow {
                        Text("Work")
                        Text("\(planeType.avail)")
                    }
                    GridRow {
                        Text("Cost")
                        Text("$\(planeType.cost)")
                    }
                    GridRow {
                        Text("Tech")
                        Text("\(planeType.tech)")
                    }
                }
                Grid(alignment: .leading) {
                    GridRow {
                        Text("Combat")
                            .gridCellColumns(2)
                            .bold()
                    }
                    GridRow {
                        Text("Accuracy")
                        Text("\(planeType.acc)")
                    }
                    GridRow {
                        Text("Load")
                        Text("\(planeType.load)")
                    }
                    GridRow {
                        Text("Attack")
                        Text("\(planeType.att)")
                    }
                    GridRow {
                        Text("Defence")
                        Text("\(planeType.def)")
                    }
                    GridRow {
                        Text("Range")
                        Text("\(planeType.ran)")
                    }
                    GridRow {
                        Text("Fuel")
                        Text("\(planeType.fuel)")
                    }
                    GridRow {
                        Text("Stealth")
                        Text("\(planeType.stealth)%")
                    }
                }
            }
        }
    }
}

#Preview {
    let units = [
        PlaneType(
            abbrev: "su",
            name: "Some Unit",
            lcmCost: 10,
            hcmCost: 11,
            crewCost: 12,
            avail: 13,
            tech: 14,
            cost: 15,
            acc: 3,
            load: 4,
            att: 5,
            def: 6,
            ran: 7,
            fuel: 8,
            stealth: 9,
            capabilities: "tactical cargo VTOL spy",
        )
    ]
    PlaneTypeReport(planeTypes: units, currTech: 7)
}
