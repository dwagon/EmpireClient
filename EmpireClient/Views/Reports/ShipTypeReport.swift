//
//  ShipTypeReport.swift
//  EmpireClient
//
//  Created by Dougal Scott on 25/8/2026.
//

import SwiftUI

struct BuildHighlight: ViewModifier {
    var canBuild: Bool

    func body(content: Content) -> some View {
        content.foregroundStyle(
            canBuild ? .primary : .secondary
        )
    }
}

struct ShipTypeReport: View {
    let shipTypes: [String: ShipType]
    let buildable: (String) -> Bool
    @Environment(\.dismiss) private var dismiss
    @State private var selectedShip: ShipType.ID?

    var body: some View {
        VStack {
            Table(Array(shipTypes.values), selection: $selectedShip) {
                TableColumn("Abbrev") { details in
                    Text("\(details.abbrev)")
                        .modifier(
                            BuildHighlight(canBuild: buildable(details.abbrev))
                        )
                }.width(min: 30, ideal: 50, max: 60)
                TableColumn("Name") { details in
                    Text("\(details.name)")
                        .modifier(
                            BuildHighlight(canBuild: buildable(details.abbrev))
                        )
                }
                TableColumn("Speed") { details in
                    Text("\(details.speed)").modifier(
                        BuildHighlight(canBuild: buildable(details.abbrev))
                    )
                }
                .width(min: 40, ideal: 50, max: 60)
                TableColumn("Tech") { details in
                    Text("\(details.tech)").modifier(
                        BuildHighlight(canBuild: buildable(details.abbrev))
                    )
                }
                .width(min: 40, ideal: 50, max: 60)
                TableColumn("Capabilities") {
                    details in
                    Text("\(details.capabilities)")
                        .modifier(
                            BuildHighlight(canBuild: buildable(details.abbrev))
                        )
                }
            }
            .tableStyle(.bordered)
            .border(.blue)
            if let selectedShip {
                Spacer()
                ShipTypeView(shipType: shipTypes[selectedShip]!, buildable: buildable(shipTypes[selectedShip]!.abbrev))
                    .border(.blue)
            }
            HStack {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }

    struct ShipTypeView: View {
        let shipType: ShipType
        let buildable: Bool

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
                        Text("\(shipType.lcmCost)")
                    }
                    GridRow {
                        Text("HCM")
                        Text("\(shipType.hcmCost)")
                    }
                    GridRow {
                        Text("Work")
                        Text("\(shipType.avail)")
                    }
                    GridRow {
                        Text("Cost")
                        Text("$\(shipType.cost)")
                    }
                    GridRow {
                        Text("Tech")
                        Text("\(shipType.tech)").foregroundStyle(buildable ? .primary : Color.red)
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
                        Text("\(shipType.visible)")
                    }
                    GridRow {
                        Text("Spy")
                        Text("\(shipType.spy)")
                    }
                }
                Grid(alignment: .leading) {
                    GridRow {
                        Text("Combat")
                            .gridCellColumns(2)
                            .bold()
                    }
                    GridRow {
                        Text("Defence")
                        Text("\(shipType.defence)")
                    }
                    GridRow {
                        Text("Range")
                        Text("\(shipType.range)")
                    }
                    GridRow {
                        Text("Fire")
                        Text("\(shipType.fire)")
                    }
                }
                Grid(alignment: .leading) {
                    GridRow {
                        Text("Mil Cargo")
                            .gridCellColumns(2)
                            .bold()
                    }
                    GridRow {
                        Text("Land Units")
                        Text("\(shipType.landUnits)")
                    }
                    GridRow {
                        Text("Light Planes")
                        Text("\(shipType.planes)")
                    }
                    GridRow {
                        Text("Extra Light Planes")
                        Text("\(shipType.lightPlanes)")
                    }
                    GridRow {
                        Text("Helicopters")
                        Text("\(shipType.helicopters)")
                    }
                }
            }
        }
    }
}

func preview_buildable(_: String) -> Bool {
    return true
}

#Preview {

    let ships = [
        "ss": ShipType(
            abbrev: "ss",
            name: "Some Ship",
            tech: 10,
            speed: 10,
            range: 10,
            capabilities: "300c 10m 900f 15u fish canal"
        )
    ]
    ShipTypeReport(shipTypes: ships, buildable: preview_buildable)
}
