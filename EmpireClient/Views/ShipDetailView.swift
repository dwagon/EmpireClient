//
//  ShipDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 27/8/2026.
//

import SwiftUI

struct ShipDetailView: View {
    @State var game: Game
    @State private var selectedShip: Ship.ID?

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
                let _ = print("DBG: shipNum=\(shipNum) ships=\(game.ships)")
                let ship = game.ships[shipNum]!
                let shipType = game.shipTypes[ship.type]!
                Divider()
                VStack(alignment: .leading) {
                    HStack {
                        Text("Ship \(selectedShip)")
                        Text("\(shipType.name.capitalized)").bold()
                        Text("'\(shipType.abbrev)'")
                    }
                    HStack {
                        Text("Defense: \(shipType.defence)")
                        Text("Speed: \(shipType.speed)")
                    }
                    HStack {
                        Text("Visibility: \(shipType.visible)")
                        Text("Spy: \(shipType.spy)")
                    }
                    HStack {
                        Text("Fire: \(shipType.fire)")
                        Text("Range: \(shipType.range)")
                    }
                    HStack {
                        Text("Civ: \(ship.civ)")
                        Text("Mil: \(ship.mil)")
                        Text("UW: \(ship.uw)")
                        Text("Cargo: \(shipType.cargo)")
                    }
                    HStack {
                        Text("Land Units: \(ship.landUnits) / \(shipType.landUnits)")
                    }
                    HStack {
                        Text("Helicopters: \(ship.heli) / \(shipType.helicopters)")
                        Text("Light Planes: \(ship.planes) / \(shipType.planes)")
                        Text(
                            "Extra Light Planes: \(ship.xlPlanes) / \(shipType.lightPlanes)"
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
