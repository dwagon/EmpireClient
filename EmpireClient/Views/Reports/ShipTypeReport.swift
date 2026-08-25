//
//  ShipTypeReport.swift
//  EmpireClient
//
//  Created by Dougal Scott on 25/8/2026.
//

import SwiftUI

struct ShipTypeReport: View {
    let shipTypes: [String: ShipType]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedShip: ShipType.ID? = nil

    var body: some View {
        VStack {
            Table(Array(shipTypes.values), selection: $selectedShip) {
                TableColumn("Abbrev", value: \.abbrev)
                    .width(min: 30, ideal: 50, max: 60)
                TableColumn("Name", value: \.name)
                TableColumn("Speed") { details in Text("\(details.speed)") }
                    .width(min: 40, ideal: 50, max: 60)
                TableColumn("Capabilities", value: \.cargo)
            }
            .tableStyle(.bordered)
            .border(.blue)
            if let selectedShip {
                Spacer()
                shipTypeView(shipType: shipTypes[selectedShip]!)
                    .border(.blue)
            }
            HStack {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }

    struct shipTypeView: View {
        let shipType: ShipType

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
                        Text("\(shipType.lcm_cost)")
                    }
                    GridRow {
                        Text("HCM")
                        Text("\(shipType.hcm_cost)")
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
                        Text("\(shipType.tech)")
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

#Preview {
    let ships = [
        "ss": ShipType(
            abbrev: "ss",
            name: "Some Ship",
            speed: 10,
            range: 10,
            cargo: "300c 10m 900f 15u fish canal"
        )
    ]
    ShipTypeReport(shipTypes: ships)
}
