//
//  HexView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/7/2026.
//

import SwiftUI
import HexGrid

struct HexView: View {
    var coord: MapCoord
    var sector: Sector

    var body: some View {
        List {
            Section {
                Text("Map: \(coord.x), \(coord.y)")
            }
            Section("Sector Details") {
                let desig = sector[.desig]
                Text("Desig: \(desig ?? "?")")
            }
        }
    }
}

//#Preview {
//    HexView()
//}
