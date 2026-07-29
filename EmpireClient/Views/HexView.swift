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
    var sector: Cell
    
    var body: some View {
        List {
            Section {
                Text("Map: \(coord.x), \(coord.y)")
            }
            Section("Sector Details") {
                Text("a")
            }
        }
    }
}

//#Preview {
//    HexView()
//}
