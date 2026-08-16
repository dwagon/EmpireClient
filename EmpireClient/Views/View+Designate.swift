//
//  View+Designate.swift
//  EmpireClient
//
//  Created by Dougal Scott on 16/8/2026.
//

import SwiftUI

struct View_Designate: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var center_coord: MapCoord
    @State private var designation: String = ""

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                isPresented = false
                if designation != "" {
                    Task {
                        await game.cmd_designate(
                            coord: center_coord,
                            designation: designation
                        )
                        await game.cmd_dump()
                    }
                }
            } content: {
                if let sector = game[center_coord] {
                    DesignateView(sector: sector, designation: $designation)
                }
            }
    }
}

extension View {
    func designate(
        isPresented: Binding<Bool>,
        game: Game,
        center_coord: MapCoord
    ) -> some View {
        modifier(
            View_Designate(
                isPresented: isPresented,
                game: game,
                center_coord: center_coord
            )
        )
    }
}
