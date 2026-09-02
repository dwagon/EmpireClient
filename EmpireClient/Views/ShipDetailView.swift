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
    @State private var showNavigatePopup: Bool = false
    @State private var showAssaultPopup: Bool = false

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
            shipButtonBar
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
        .loadShip(isPresented: $showLoadPopup, game: game, shipId: selectedShip)
        .assaultShip(
            isPresented: $showAssaultPopup,
            game: game,
            shipId: selectedShip
        )
        .navigateShip(
            isPresented: $showNavigatePopup,
            game: game,
            shipId: selectedShip
        )

    }

    var shipButtonBar: some View {
        VStack {
            refreshButton

            if selectedShip != nil {
                loadButton
                navigateButton
                assaultButton
            }
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
            Text("Capabilities: \(shipType.cargo)")
            HStack {
                Text("Civ: \(ship.civ)")
                Text("Mil: \(ship.mil)")
                Text("UW: \(ship.uw)")
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

    var refreshButton: some View {
        return
            Button("Refresh") {
                Task {
                    await game.cmd_ship()
                }
            }
    }

    var loadButton: some View {
        Button("Load") {
            showLoadPopup = true
        }
    }

    var assaultButton: some View {
        Button("Assault") {
            showAssaultPopup = true
        }
    }

    var navigateButton: some View {
        Button("Navigate") {
            showNavigatePopup = true
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
