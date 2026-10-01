//
//  LandDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/9/2026.
//

import SwiftUI

struct LandDetailView: View {
    var game: Game
    var unit: LandUnit

    var body: some View {
        let unitType = game.landTypes[unit.abbrev]!

        return VStack(alignment: .leading) {
            HStack {
                Text("Land Unit \(unit.number)")
                Text("\(unitType.name.capitalized)").bold()
                Text("'\(unitType.abbrev)'")
            }.font(.title2)
            HStack {
                Text("Mobility: \(unit.mob)")
                Text("Speed: \(unit.speed)")
                Text("Visibility: \(unit.visibility)")
                Text("Spy: \(unit.spy)")
                Text("Tech: \(unit.tech)")
            }
            HStack {
                Text(
                    "Defense: \(unit.defense, format: .number.precision(.fractionLength(1)))"
                )
                Text("Vulnerability: \(unit.vulnerability)")
                Text("Fortification: \(unit.fortification)")
                Text("Retreat: \(unit.retreat)%")
                Text("Reaction Radius: \(unit.react)")
            }
            HStack {
                Text(
                    "Attack: \(unit.attack, format: .number.precision(.fractionLength(1)))"
                )
                Text("Ammo Use: \(unit.ammoUse)")
                Text("Firing Range: \(unit.frg)")
                Text("Accuracy: \(unit.accuracy)")
                Text("Damage: \(unit.damage)")
            }
            Text("Capabilities: \(unitType.capabilities)")
            Divider()
            HStack {
                ForEach(
                    unit.cargo.sorted(by: {
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
            Text(unit.ship < 0 ? "" : "Loaded on to Ship \(unit.ship)")
        }.padding()
            .border(.blue)
    }
}
