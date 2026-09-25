//
//  FleetAddView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/9/2026.
//

import SwiftUI

struct FleetAddView: View {
    var game: Game
    var ship: Ship
    @Binding var fleet: String
    @FocusState private var focused: Bool
    var onButton: () -> Void

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Label(
                "Add Ship \(ship.number) to Fleet",
                systemImage: "oar.2.crossed"
            )
            .font(
                .title
            )
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        TextField(
                            "Fleet",
                            text: $fleet
                        )
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .frame(idealWidth: 100, maxWidth: 150)
                        .onChange(of: fleet) { _, newValue in
                            if newValue.count > 1 {
                                fleet = String(newValue.prefix(1))
                            }
                        }
                    }
                }
            }
            HStack {
                CancelButton()
                OkButton("Add") {
                    onButton()
                }
            }
        }.padding()
    }
}

struct FleetAddSheet: ViewModifier {
    @Binding var isPresented: Bool
    @State var fleet: String = ""
    var game: Game
    var shipId: Ship.ID?

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                if let shipId, let ship = game.ships[shipId] {
                    FleetAddView(
                        game: game,
                        ship: ship,
                        fleet: $fleet
                    ) {
                        Task {
                            await game.cmd_fleetadd(fleet: fleet, ship: ship)
                            await game.cmd_sdump(ship)
                        }
                    }
                    .onAppear {
                        fleet = ship.fleet
                    }
                }
            }
    }
}

extension View {
    func fleetAdd(
        isPresented: Binding<Bool>,
        game: Game,
        shipId: Ship.ID?
    ) -> some View {
        modifier(
            FleetAddSheet(
                isPresented: isPresented,
                game: game,
                shipId: shipId
            )
        )
    }
}
