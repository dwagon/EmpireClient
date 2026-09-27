//
//  LandDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 15/9/2026.
//

import SwiftUI

struct LandDetailView: View {
    @State var game: Game
    @Binding var centerCoord: MapCoord
    @State private var selectedUnit: Plane.ID?

    @State private var showMarchPopup: Bool = false
    @State private var showLLandPopup: Bool = false

    var body: some View {
        HStack {
            VStack {
                Table(game.landTable, selection: $selectedUnit) {
                    TableColumn("Unit #") { val in
                        Text("\(val.number)")
                    }
                    .standardWidth()
                    TableColumn("Type") { val in
                        Text(
                            "\(game.landTypes[val.abbrev]!.name) (\(val.abbrev))"
                        )
                    }
                    TableColumn("Coord") { val in
                        Text("\(val.coords.toString(), default: "unknown")")
                    }.standardWidth()

                    TableColumn("Mil") { val in
                        Text("\(val.cargo[.mil], default: "?")")
                    }.standardWidth()

                    TableColumn("Army") { val in Text("\(val.army)") }
                        .standardWidth()

                    TableColumn("Mob") { val in Text("\(val.mob)") }
                        .standardWidth()
                    TableColumn("Eff") { val in Text("\(val.eff)%") }
                        .standardWidth()
                    TableColumn("Notes") { val in
                        if val.ship >= 0 {
                            Text("Aboard S\(val.ship)")
                        }
                    }
                }
                .onChange(of: selectedUnit) {
                    centerCoord = game.landUnits[selectedUnit!]!.coords
                }
                if let selectedUnit {
                    if game.landUnits[selectedUnit] != nil {
                        Divider()
                        landDetails
                    } else {
                        Text("Unit doesn't exist")
                    }
                }
            }
            landButtonBar
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 800)
        .marchUnit(
            isPresented: $showMarchPopup,
            game: game,
            unitId: selectedUnit
        )
        .loadLandUnit(
            isPresented: $showLLandPopup,
            game: game,
            unitId: selectedUnit
        )
    }

    var landButtonBar: some View {
        VStack {
            refreshButton

            if selectedUnit != nil {
                marchButton
                loadLandButton
            }
        }
    }

    var marchButton: some View {
        Button("March") {
            showMarchPopup = true
        }
    }

    var loadLandButton: some View {
        Button("Load") {
            showLLandPopup = true
        }
    }

    var landDetails: some View {
        let unitNum = selectedUnit!
        let unit = game.landUnits[unitNum]!
        let unitType = game.landTypes[unit.abbrev]!

        return VStack(alignment: .leading) {
            HStack {
                Text("Land Unit \(unitNum)")
                Text("\(unitType.name.capitalized)").bold()
                Text("'\(unitType.abbrev)'")
            }
            HStack {
                Text("Mobility: \(unit.mob)")
                Text("Speed: \(unit.speed)")
                Text("Visibility: \(unit.visibility)")
                Text("Spy: \(unit.spy)")
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

    var refreshButton: some View {
        return
            Button("Refresh") {
                Task {
                    await game.cmd_map()
                    await game.cmd_ldump()
                }
            }
    }

}

#Preview {
    @Previewable @State var game = DataLoader.loadSampleGame(
        name: "Game_ShipView"
    )
    @Previewable @State var centerCoord = MapCoord(x: 0, y: 0)
    LandDetailView(game: game, centerCoord: $centerCoord)

}
