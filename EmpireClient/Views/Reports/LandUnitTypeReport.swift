//
//  LandTypeReport.swift
//  EmpireClient
//
//  Created by Dougal Scott on 11/9/2026.
//

import SwiftUI

struct LandTypeReport: View {
    let landTypes: [LandType]
    let currTech: Float

    @Environment(\.dismiss) private var dismiss
    @State private var selectedUnit: LandType.ID?

    var body: some View {
        VStack {
            Table(landTypes, selection: $selectedUnit) {
                TableColumn("Abbrev") { details in
                    Text("\(details.abbrev)").modifier(
                        BuildableHighlight(
                            canBuild: details.isBuildable(
                                techlevel: currTech
                            )
                        )
                    )
                }
                .width(min: 30, ideal: 50, max: 60)
                TableColumn("Name") { details in
                    Text("\(details.name)").modifier(
                        BuildableHighlight(
                            canBuild: details.isBuildable(
                                techlevel: currTech
                            )
                        )
                    )
                }
                .width(min: 60, ideal: 100, max: 120)
                TableColumn("Speed") { details in
                    Text("\(details.speed)").modifier(
                        BuildableHighlight(
                            canBuild: details.isBuildable(
                                techlevel: currTech
                            )
                        )
                    )
                }
                .width(min: 40, ideal: 50, max: 60)
                TableColumn("Tech") { details in
                    Text("\(details.tech)").modifier(
                        BuildableHighlight(
                            canBuild: details.isBuildable(
                                techlevel: currTech
                            )
                        )
                    )
                }
                .width(min: 40, ideal: 50, max: 60)
                TableColumn("Capabilities") { details in
                    Text("\(details.capabilities)").modifier(
                        BuildableHighlight(
                            canBuild: details.isBuildable(
                                techlevel: currTech
                            )
                        )
                    )
                }
            }
            .tableStyle(.bordered)
            .border(.blue)
            if let selectedUnit {
                Spacer()
                if let land = landTypes.first(where: { $0.id == selectedUnit })
                {
                    LandTypeView(unitType: land)
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

    struct LandTypeView: View {
        let unitType: LandType

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
                        Text("Guns")
                        Text("\(unitType.gunCost)")
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
                        Text("Vision")
                            .gridCellColumns(2)
                            .bold()
                    }
                    GridRow {
                        Text("Visibility")
                        Text("\(unitType.visible)")
                    }
                    GridRow {
                        Text("Spy")
                        Text("\(unitType.spy)")
                    }
                }
                Grid(alignment: .leading) {
                    GridRow {
                        Text("Combat")
                            .gridCellColumns(2)
                            .bold()
                    }
                    GridRow {
                        Text("Attack")
                        Text(
                            "\(unitType.att, format: .number.precision(.fractionLength(1)))"
                        )
                    }
                    GridRow {
                        Text("Defence")
                        Text(
                            "\(unitType.def, format: .number.precision(.fractionLength(1)))"
                        )
                    }
                    GridRow {
                        Text("Range")
                        Text("\(unitType.range)")
                    }
                    GridRow {
                        Text("Accuracy")
                        Text("\(unitType.accuracy)")
                    }
                    GridRow {
                        Text("Fire")
                        Text("\(unitType.fire)")
                    }
                    GridRow {
                        Text("Ammo")
                        Text("\(unitType.ammo)")
                    }
                    GridRow {
                        Text("Vulnerability")
                        Text("\(unitType.vulnerability)")
                    }
                }
            }
        }
    }
}

#Preview {
    let units = [
        LandType(
            abbrev: "su",
            name: "Some Unit",
            lcmCost: 10,
            hcmCost: 11,
            gunCost: 12,
            avail: 13,
            tech: 14,
            cost: 15,
            att: 3.1,
            def: 4.2,
            vulnerability: 3,
            speed: 10,
            visible: 11,
            spy: 12,
            reactionRadius: 3,
            range: 10,
            accuracy: 11,
            fire: 12,
            ammo: 13,
            aaf: 0,
            xpl: 1,
            lnd: 1,
            capabilities:
                "990m 990s 200g 990p 500i 500d 100b 990f 990o 990l 990h 150r supply train heavy",
        )
    ]
    LandTypeReport(landTypes: units, currTech: 20)
}
