//
//  ShipDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 27/8/2026.
//

import SwiftUI

struct ShipDetailView: View {
    @State var game: Game
    @Binding var centerCoord: MapCoord
    @State private var selectedShip: Ship.ID?

    @State private var showLoadPopup: Bool = false

    var body: some View {
        HStack {
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
                .onChange(of: selectedShip) {
                    centerCoord = game.ships[selectedShip!]!.coords
                }

                if selectedShip != nil {
                    Divider()
                    shipDetails
                }
            }
            if selectedShip != nil {
                shipButtonBar
            }
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
        .loadShip(isPresented: $showLoadPopup, game: game, shipId: selectedShip)
    }

    var shipButtonBar: some View {
        VStack {
            loadButton
        }
    }

    var shipDetails: some View {
        let shipNum = selectedShip!
        let ship = game.ships[shipNum]!
        let shipType = game.shipTypes[ship.type]!

        return VStack(alignment: .leading) {
            HStack {
                Text("Ship \(shipNum)")
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

    var loadButton: some View {
        Button("Load") {
            showLoadPopup = true
        }
    }
}

#Preview {
    @Previewable @State var game = DataLoader.loadSampleGame(
        name: "Game_ShipView"
    )
    @Previewable @State var centerCoord = MapCoord(x: 0, y: 0)
    ShipDetailView(game: game, centerCoord: $centerCoord)

}
