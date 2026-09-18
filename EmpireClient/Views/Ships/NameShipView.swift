//
//  NameShipView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 17/9/2026.
//

import SwiftUI

struct NameShipView: View {
    var game: Game
    var shipNum: String
    @Binding var name: String
    @FocusState private var focused: Bool
    var onButton: () -> Void

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Label(
                "Name Ship \(shipNum)",
                systemImage: "person.text.rectangle.fill"
            )
            .font(
                .title
            )
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        TextField(
                            "Name",
                            text: $name
                        )
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .frame(idealWidth: 100, maxWidth: 150)
                    }
                }
            }
            HStack {
                Button("Cancel", role: .cancel) {
                    name = ""
                    dismiss()
                }
                .buttonStyle(.automatic)
                .padding()
                Button("Name") {
                    onButton()
                    dismiss()
                }
            }
        }.padding()
    }
}

struct NameShipSheet: ViewModifier {
    @Binding var isPresented: Bool
    @State var name: String = ""
    var game: Game
    var shipId: Ship.ID?

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                if let shipId, let ship = game.ships[shipId] {
                    NameShipView(
                        game: game,
                        shipNum: game.ships[shipId]!.number,
                        name: $name
                    ) {
                        Task {
                            await game.cmd_name(ship: shipId, name: name)
                            await game.cmd_sdump(shipId)
                        }
                    }
                    .onAppear {
                        name = ship.name
                    }
                }
            }
    }
}

extension View {
    func nameShip(
        isPresented: Binding<Bool>,
        game: Game,
        shipId: Ship.ID?
    ) -> some View {
        modifier(
            NameShipSheet(
                isPresented: isPresented,
                game: game,
                shipId: shipId
            )
        )
    }
}
