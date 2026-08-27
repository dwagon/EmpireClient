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
                    Text("\(val.type.name) (\(val.type.abbrev))")
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
                let shipNum = Int(selectedShip)!
                let ship = game.ships[shipNum]!
                Divider()
                VStack(alignment: .leading) {
                    HStack {
                        Text("Ship \(selectedShip)")
                        Text("\(ship.type.name)")
                        Text("\(ship.type.abbrev)")
                    }
                    HStack {
                        Text("Defense: \(ship.type.defence)")
                        Text("Speed: \(ship.type.speed)")
                    }
                    HStack {
                        Text("Visibility: \(ship.type.visible)")
                        Text("Spy: \(ship.type.spy)")
                    }
                    HStack {
                        Text("Fire: \(ship.type.fire)")
                        Text("Range: \(ship.type.range)")
                    }
                    HStack {
                        Text("Civ: \(ship.civ)")
                        Text("Mil: \(ship.mil)")
                        Text("UW: \(ship.uw)")
                        Text("Cargo: \(ship.type.cargo)")
                    }
                    HStack {
                        Text("Land Units: \(ship.landUnits) / \(ship.type.landUnits)")
                        Text("Helicopters: \(ship.heli) / \(ship.type.helicopters)")
                        Text("Light Planes: \(ship.planes) / \(ship.type.planes)")
                        Text("Extra Light Planes: \(ship.xlPlanes) / \(ship.type.lightPlanes)")
                    }
                }
            }
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
    }
}

#Preview {
    @Previewable @State var game = Game()
    ShipDetailView(game: game)
}
