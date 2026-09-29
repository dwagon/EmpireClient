//
//  ShipDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/9/2026.
//

import SwiftUI

struct ShipDetailView: View {
    var game: Game
    var selectedShip: Ship.ID?

    var body: some View {
        let shipNum = selectedShip!
        let ship = game.ships[shipNum]!
        let shipType = game.shipTypes[ship.abbrev]!

        return VStack(alignment: .leading) {
            HStack {
                Text("Ship \(shipNum)")
                Text("\(shipType.name.capitalized)").bold()
                Text("'\(shipType.abbrev)'")
            }
            HStack {
                Text("Defense: \(ship.defense)")
                Text("Speed: \(ship.speed)")
                Text("Tech: \(ship.tech )")
            }
            HStack {
                Text("Visibility: \(ship.visibility)")
                Text("Spy: \(shipType.spy)")
            }
            HStack {
                Text(ship.fire == 0 ? "" : "Fire: \(ship.fire)")
                Text(ship.range == 0 ? "" : "Range: \(ship.range)")
            }
            HStack {
                Text("Land Units: \(shipType.landUnits)")
                Text("Helicopters: \(shipType.helicopters)")
                Text("Planes: \(shipType.planes)")
                Text("L Planes: \(shipType.lightPlanes)")
            }
            Text("Capabilities: \(shipType.capabilities)")
            Divider()
            HStack {
                ForEach(
                    ship.cargo.sorted(by: {
                        $0.key.displayName < $1.key.displayName
                    }),
                    id: \.key
                ) { key, value in
                    if value != 0 {
                        Text(
                            "\(key.displayName.capitalized): \(value, default: "?")"
                        )
                    }
                }
            }
            VStack {
                HStack {
                    Text(
                        ship.landUnits == 0
                            ? ""
                            : "Land Units: \(ship.landUnits) / \(shipType.landUnits)"
                    )
                    ForEach(game.landUnitsAboard(ship)) { unit in
                        Text("Unit \(unit.number): \(unit.abbrev)")
                    }
                }
                Text(
                    ship.heli == 0
                        ? ""
                        : "Helicopters: \(ship.heli) / \(shipType.helicopters)"
                )
                Text(
                    ship.planes == 0
                        ? ""
                        : "Light Planes: \(ship.planes) / \(shipType.planes)"
                )
                Text(
                    ship.xlPlanes == 0
                        ? ""
                        : "Extra Light Planes: \(ship.xlPlanes) / \(shipType.lightPlanes)"
                )
            }
        }.padding()
            .border(.blue)
    }
}
