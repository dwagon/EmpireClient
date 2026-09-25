//
//  NukeTypeReport.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/9/2026.
//

import SwiftUI

struct NukeTypeReport: View {
    let nukeTypes: [NukeType]
    let currTech: Float

    @Environment(\.dismiss) private var dismiss
    @State private var selectedUnit: NukeType.ID?

    var body: some View {
        VStack {
            Table(nukeTypes, selection: $selectedUnit) {
                TableColumn("Name") { details in
                    Text("\(details.name)").buildableHighlight(
                        details.isBuildable(techlevel: currTech)
                    )
                }
                .width(min: 60, ideal: 100, max: 120)

                TableColumn("Blast") { details in
                    Text("\(details.blast)").buildableHighlight(
                        details.isBuildable(techlevel: currTech)
                    )
                }
                .width(min: 30, ideal: 50, max: 60)

                TableColumn("Damage") { details in
                    Text("\(details.damage)").buildableHighlight(
                        details.isBuildable(techlevel: currTech)
                    )
                }
                .width(min: 30, ideal: 50, max: 60)

                TableColumn("Tech") { details in
                    Text("\(details.tech)").buildableHighlight(
                        details.isBuildable(techlevel: currTech)
                    )

                }
                .width(min: 30, ideal: 50, max: 60)

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
                if let nuke = nukeTypes.first(where: { $0.id == selectedUnit }
                ) {
                    NukeTypeView(nukeType: nuke)
                        .border(.blue).padding()
                }
            }
            OkButton()
        }
    }

    struct NukeTypeView: View {
        let nukeType: NukeType

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
                        Text("\(nukeType.lcmCost)")
                    }
                    GridRow {
                        Text("HCM")
                        Text("\(nukeType.hcmCost)")
                    }
                    GridRow {
                        Text("Oil")
                        Text("\(nukeType.oilCost)")
                    }
                    GridRow {
                        Text("Rads")
                        Text("\(nukeType.radCost)")
                    }
                    GridRow {
                        Text("Work")
                        Text("\(nukeType.avail)")
                    }
                    GridRow {
                        Text("Cost")
                        Text("$\(nukeType.cost)")
                    }
                    GridRow {
                        Text("Tech")
                        Text("\(nukeType.tech)")
                    }
                }
                Grid(alignment: .leading) {
                    GridRow {
                        Text("Combat")
                            .gridCellColumns(2)
                            .bold()
                    }
                    GridRow {
                        Text("Blast")
                        Text("\(nukeType.blast)")
                    }
                    GridRow {
                        Text("Damage")
                        Text("\(nukeType.damage)")
                    }
                    GridRow {
                        Text("Weight")
                        Text("\(nukeType.lbs) lbs")
                    }

                }
            }
        }
    }
}

#Preview {
    let units = [
        NukeType(
            abbrev: "boom",
            name: "BigBoom",
            lcmCost: 50,
            hcmCost: 50,
            oilCost: 25,
            radCost: 70,
            avail: 49,
            tech: 280,
            research: 0,
            cost: 10_000,
            blast: 3,
            damage: 70,
            lbs: 4,
            capabilities: "Extra Spicy"
        )
    ]
    NukeTypeReport(nukeTypes: units, currTech: 7)
}
