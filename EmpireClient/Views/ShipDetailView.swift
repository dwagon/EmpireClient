//
//  ShipDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 27/8/2026.
//

import SwiftUI

struct ShipDetailView: View {
    @State var game: Game
    @State private var selectedShip: Ship.ID? = nil

    var body: some View {
        VStack {
            Table(game.shipTable, selection: $selectedShip) {
                TableColumn("Ship #") { val in Text("\(val.number)") }
                    .width(min: 20, ideal: 30, max: 60)
                TableColumn("Type") { val in
                    Text("\(game.shipTypes[val.type]!.name) (\(val.type))")
                }
                TableColumn("Coord") { val in
                    Text("\(val.coords.toString(), default: "unknown")")
                }.width(min: 20, ideal: 30, max: 60)

                TableColumn("Mob") { val in Text("\(val.mob)") }.width(
                    min: 20,
                    ideal: 30,
                    max: 60
                )
                TableColumn("Eff") { val in Text("\(val.eff)%") }.width(
                    min: 20,
                    ideal: 30,
                    max: 60
                )
                TableColumn("Food") { val in Text("\(val.food)") }.width(
                    min: 20,
                    ideal: 30,
                    max: 60
                )
            }

            if let selectedShip {
                let shipNum = String(selectedShip)
                let ship = game.ships[shipNum]!
                let st = game.shipTypes[ship.type]!
                Divider()
                VStack(alignment: .leading) {
                    HStack {
                        Text("Ship \(selectedShip)")
                        Text("\(st.name.capitalized)").bold()
                        Text("'\(st.abbrev)'")
                    }
                    HStack {
                        Text("Defense: \(st.defence)")
                        Text("Speed: \(st.speed)")
                    }
                    HStack {
                        Text("Visibility: \(st.visible)")
                        Text("Spy: \(st.spy)")
                    }
                    HStack {
                        Text("Fire: \(st.fire)")
                        Text("Range: \(st.range)")
                    }
                    HStack {
                        Text("Civ: \(ship.civ)")
                        Text("Mil: \(ship.mil)")
                        Text("UW: \(ship.uw)")
                        Text("Cargo: \(st.cargo)")
                    }
                    HStack {
                        Text("Land Units: \(ship.landUnits) / \(st.landUnits)")
                    }
                    HStack {
                        Text("Helicopters: \(ship.heli) / \(st.helicopters)")
                        Text("Light Planes: \(ship.planes) / \(st.planes)")
                        Text(
                            "Extra Light Planes: \(ship.xlPlanes) / \(st.lightPlanes)"
                        )
                    }
                }
            }
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
    }
}

#Preview {
    @Previewable @State var game = DataLoader.loadSampleGame(
        name: "Game_ShipView"
    )
    ShipDetailView(game: game)

}
