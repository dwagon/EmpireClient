//
//  PlaneDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 13/9/2026.
//

import SwiftUI

struct PlaneDetailView: View {
    var game: Game
    var plane: Plane

    var body: some View {
        let planeType = game.planeTypes[plane.abbrev]!

        VStack(alignment: .leading) {
            HStack {
                Text("Plane \(plane.number)")
                Text("\(planeType.name.capitalized)").bold()
                Text("'\(planeType.abbrev)'")
            }.font(.title2)
            HStack {
                Text("Range: \(plane.range)")
                Text("React: \(plane.react)")
                Text("Fuel: \(plane.fuel)")
                Text("Tech: \(plane.tech)")
            }
            HStack {
                Text("Attack: \(plane.attack)")
                Text("Defense: \(plane.defence)")
                Text("Accuracy: \(plane.accuracy)")
            }
            Text("Capabilities: \(planeType.capabilities)")
            Divider()
        }.padding()
            .border(.blue)
    }
}
