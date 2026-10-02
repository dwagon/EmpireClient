//
//  WingAddView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 2/10/2026.
//

import SwiftUI

struct WingAddView: View {
    var game: Game
    var plane: Plane
    @Binding var viewMode: PlaneViewMode
    @State var wing: String = ""
    @FocusState private var focused: Bool

    init(
        game: Game,
        plane: Plane,
        viewMode: Binding<PlaneViewMode>
    ) {
        self.game = game
        self.plane = plane
        self._viewMode = viewMode

        let existingWing = plane.wing
        self._wing = State(initialValue: existingWing)
    }

    var body: some View {
        VStack {
            Label(
                "Add Plane \(plane.number) to Wing",
                systemImage: "airplane.ticket"
            )
            .font(
                .title
            )
            HStack {
                TextField(
                    "Wing",
                    text: $wing
                )
                .focused($focused)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .frame(idealWidth: 100, maxWidth: 150)
                .onChange(of: wing) { _, newValue in
                    if newValue.count > 1 {
                        wing = String(newValue.prefix(1))
                    }
                }
            }
            HStack {
                CancelButton {
                    viewMode = .overview
                }
                OkButton("Add", disabled: wing.isEmpty) {
                    Task {
                        await addToWing()
                        viewMode = .overview
                    }
                }
            }
        }.padding()
            .onAppear {
                focused = true
            }
    }

    func addToWing() async {
        await game.cmd_wingadd(wing: wing, plane: plane)
        await game.cmd_pdump(plane: plane)
    }
}
