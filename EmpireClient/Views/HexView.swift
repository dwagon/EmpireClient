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
                Text("Desig: \(String(describing: sector.desig))")
                Grid {
                    GridRow{
                        Text("Civilians")
                        Text("Military")
                        Text("Uncomp Workers")
                    }
                    Divider()
                    GridRow{
                        Text("\(String(describing: sector[.civ]))")
                        Text("\(String(describing: sector[.mil]))")
                        Text("\(String(describing: sector[.uw]))")

                    }
                }
            }
        }
    }
}

//#Preview {
//    HexView()
//}
