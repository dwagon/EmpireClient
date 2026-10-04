//
//  LaunchView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 4/10/2026.
//

import SwiftUI

struct LaunchView: View {
    var game: Game
    var plane: Plane
    @Binding var destination: MapCoord
    @Binding var viewMode: PlaneViewMode
    @Binding var sectorSelect: Bool
    
    @State var geosync: Bool = false

    var body: some View {
        VStack {
            Label(
                "Launch \(plane.number)",
                systemImage: "airplane.up.forward"
            )
            .font(
                .title
            )
            HStack {
                Toggle("Geosync Orbit?", isOn: $geosync)
            }
            HStack {
                CancelButton {
                    viewMode = .overview
                    sectorSelect = true
                }
                OkButton("Launch to \(destination.toString())") {
                    sectorSelect = true
                    Task {
                        await launch(dest: destination, geosync: geosync)
                        viewMode = .overview
                    }
                }
            }
        }.padding()
            .onAppear {
                sectorSelect=false
            }
    }

    func launch(dest: MapCoord, geosync: Bool) async {
        await game.cmd_launch(plane: plane, dest: dest, geosync: geosync)
        await game.cmd_pdump(plane: plane)
    }
}
