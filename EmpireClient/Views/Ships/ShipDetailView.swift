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
    @State private var showUnloadPopup: Bool = false
    @State private var showNavigatePopup: Bool = false
    @State private var showAssaultPopup: Bool = false
    @State private var showNamePopup: Bool = false
    @State private var showFleetAddPopup: Bool = false

    var body: some View {
        let minColWidth: CGFloat = 60
        let idealColWidth: CGFloat = 80
        let maxColWidth: CGFloat = 100
        HStack {
            VStack {
                Table(game.shipTable, selection: $selectedShip) {
                    TableColumn("Ship #") { val in Text("\(val.number)") }
                        .width(
                            min: minColWidth,
                            ideal: idealColWidth,
                            max: maxColWidth
                        )

                    TableColumn("Name") { val in
                        Text("\(val.name)")
                    }

                    TableColumn("Type") { val in
                        Text(
                            "\(game.shipTypes[val.abbrev]!.name) (\(val.abbrev))"
                        )
                    }

                    TableColumn("Coord") { val in
                        Text("\(val.coords.toString(), default: "unknown")")
                    }.width(
                        min: minColWidth,
                        ideal: idealColWidth,
                        max: maxColWidth
                    )

                    TableColumn("Fleet") { val in
                        Text("\(val.fleet)")
                    }.width(
                        min: minColWidth,
                        ideal: idealColWidth,
                        max: maxColWidth
                    )

                    TableColumn("Mob") { val in Text("\(val.mob)") }.width(
                        min: minColWidth,
                        ideal: idealColWidth,
                        max: maxColWidth
                    )

                    TableColumn("Eff") { val in Text("\(val.eff)%") }.width(
                        min: minColWidth,
                        ideal: idealColWidth,
                        max: maxColWidth
                    )
                }
                .onChange(of: selectedShip) {
                    centerCoord = game.ships[selectedShip!]!.coords
                }
                .onChange(of: showNavigatePopup) {
                    centerCoord = game.ships[selectedShip!]!.coords
                }

                if selectedShip != nil {
                    if let shipNum = selectedShip, game.ships[shipNum] != nil {
                        Divider()
                        shipDetails
                    } else {
                        Text("Ship doesn't exist")
                    }
                }
            }
            shipButtonBar
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
        .loadShip(isPresented: $showLoadPopup, game: game, shipId: selectedShip)
        .unloadShip(
            isPresented: $showUnloadPopup,
            game: game,
            shipId: selectedShip
        )
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
        .nameShip(
            isPresented: $showNamePopup,
            game: game,
            shipId: selectedShip
        )
        .fleetAdd(
            isPresented: $showFleetAddPopup,
            game: game,
            shipId: selectedShip
        )
        .task {
            await game.cmd_ldump()  // Get land units at the same location / cargo
        }
    }

    var shipButtonBar: some View {
        VStack {
            refreshButton

            if selectedShip != nil {
                loadButton
                unloadButton
                navigateButton
                assaultButton
                nameButton
                fleetAddButton
            }
        }
    }

    var shipDetails: some View {
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

    var refreshButton: some View {
        return
            Button("Refresh") {
                Task {
                    await game.cmd_map()
                    await game.cmd_sdump()
                }
            }
    }

    var loadButton: some View {
        Button("Load") {
            showLoadPopup = true
        }
    }

    var unloadButton: some View {
        Button("Unload") {
            showUnloadPopup = true
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

    var nameButton: some View {
        Button("Name") {
            showNamePopup = true
        }
    }

    var fleetAddButton: some View {
        Button("Add to Fleet") {
            showFleetAddPopup = true
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
