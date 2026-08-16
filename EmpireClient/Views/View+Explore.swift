//
//  View+Explore.swift
//  EmpireClient
//
//  Created by Dougal Scott on 16/8/2026.
//

import SwiftUI

struct View_Explore: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var center_coord: MapCoord
    @State private var item: Item = .mil
    @State private var number: Int = 1
    @State private var destination: String = ""

    func body(content: Content) -> some View {
        content
        .sheet(
            isPresented: $isPresented
        ) {
            isPresented = false
            if number > 0 {
                Task {
                    await game.cmd_explo(
                        item: item,
                        sector: center_coord,
                        number: number,
                        destination: destination
                    )
                    await game.cmd_dump()
                    await game.cmd_bmap()
                    number = 0
                    destination = ""
                    item = .civ
                }
            }
        } content: {
            ExploreView(
                coord: center_coord,
                item: $item,
                number: $number,
                destination: $destination
            )
        }
    }
}

extension View {
    func explore(
        isPresented: Binding<Bool>,
        game: Game,
        center_coord: MapCoord
    ) -> some View {
        modifier(
            View_Explore(
                isPresented: isPresented,
                game: game,
                center_coord: center_coord
            )
        )
    }
}
