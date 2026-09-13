//
//  PlaneTypeReport.swift
//  EmpireClient
//
//  Created by Dougal Scott on 13/9/2026.
//

import SwiftUI

struct PlaneTypeReport: View {
    let planeTypes: [String: PlaneType]

    @Environment(\.dismiss) private var dismiss
    @State private var selectedUnit: PlaneType.ID?

    var body: some View {
        VStack {
            Table(Array(planeTypes.values), selection: $selectedUnit) {
                TableColumn("Abbrev", value: \.abbrev)
                    .width(min: 30, ideal: 50, max: 60)
                TableColumn("Name", value: \.name)
                    .width(min: 60, ideal: 100, max: 120)
                TableColumn("Tech") { details in
                    Text("\(details.tech)")
                }
                .width(min: 60, ideal: 100, max: 120)
                TableColumn("Capabilities", value: \.capabilities)
            }
            .tableStyle(.bordered)
            .border(.blue)
            if let selectedUnit {
                Spacer()
                PlaneTypeView(unitType: planeTypes[selectedUnit]!)
                    .border(.blue).padding()
            }
            HStack {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }

    struct PlaneTypeView: View {
        let unitType: PlaneType

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
                        Text("\(unitType.lcmCost)")
                    }
                    GridRow {
                        Text("HCM")
                        Text("\(unitType.hcmCost)")
                    }
                    GridRow {
                        Text("Crew")
                        Text("\(unitType.crewCost)")
                    }
                    GridRow {
                        Text("Work")
                        Text("\(unitType.avail)")
                    }
                    GridRow {
                        Text("Cost")
                        Text("$\(unitType.cost)")
                    }
                    GridRow {
                        Text("Tech")
                        Text("\(unitType.tech)")
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
                        Text("\(unitType.acc)")
                    }
                    GridRow {
                        Text("Load")
                        Text("\(unitType.load)")
                    }
                    GridRow {
                        Text("Attack")
                        Text("\(unitType.att)")
                    }
                    GridRow {
                        Text("Defence")
                        Text("\(unitType.def)")
                    }
                    GridRow {
                        Text("Range")
                        Text("\(unitType.ran)")
                    }
                    GridRow {
                        Text("Fuel")
                        Text("\(unitType.fuel)")
                    }
                    GridRow {
                        Text("Stealth")
                        Text("\(unitType.stealth)%")
                    }
                }
            }
        }
    }
}

#Preview {
    let units = [
        "ss": PlaneType(
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
    PlaneTypeReport(planeTypes: units)
}
