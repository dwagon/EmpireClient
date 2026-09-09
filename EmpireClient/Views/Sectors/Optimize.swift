//
//  Optimize.swift
//  EmpireClient
//
//  Created by Dougal Scott on 8/9/2026.
//

import SwiftUI

enum OptimizeType: Hashable {
    case none
    case individual
    case global
    case desig(Desig)
}

struct OptimizeView: View {
    var sector: Sector
    @Binding var optimizeType: OptimizeType

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Label("Optimize Thresholds", systemImage: "cloud.rainbow.crop")
                .font(
                    .title
                )
            HStack {
                optimizeDetails.padding()
                Spacer()
            }
            switch optimizeType {
            case .none:
                EmptyView()
            case .individual:
                Text("Optimize at \(sector.coords.toString())")
            case .global:
                Text("Optimize everywhere")
            case .desig(let desig):
                Text("Optimize all \(desig.name)s")
            }
            HStack {
                Button("Cancel", role: .cancel) {
                    optimizeType = .none
                    dismiss()
                }
                .padding()
                Button("Optimize") {
                    dismiss()
                }
            }.buttonStyle(.automatic)
        }
    }

    var optimizeDetails: some View {
        return VStack {
            Picker(
                "Target",
                selection: $optimizeType,
                content: {
                    Text("Global").tag(OptimizeType.global)
                    Text("Just \(sector.coords.toString())").tag(
                        OptimizeType.individual
                    )
                    Text("All \(sector.desig.name)").tag(
                        OptimizeType.desig(sector.desig)
                    )
                }
            ).pickerStyle(.segmented)
                .pickerStyle(.automatic)
                .padding()
        }
    }
}

struct OptimizeSheet: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var centerCoord: MapCoord
    @State private var optimizeType: OptimizeType = .none

    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                isPresented = false
                Task {
                    switch optimizeType {
                    case .none:
                        break
                    case .individual:
                        game.optimize(coord: centerCoord)
                    case .global:
                        game.optimize()
                    case .desig(let desig):
                        game.optimize(desig: desig)
                    }
                    await game.cmd_dump()
                }
            } content: {
                OptimizeView(
                    sector: game[centerCoord]!,
                    optimizeType: $optimizeType
                )
            }
    }
}

extension View {
    func optimize(
        isPresented: Binding<Bool>,
        game: Game,
        centerCoord: MapCoord
    ) -> some View {
        modifier(
            OptimizeSheet(
                isPresented: isPresented,
                game: game,
                centerCoord: centerCoord
            )
        )
    }
}

#Preview {
    @Previewable var game = Game()
    @Previewable var coord = MapCoord(x: 0, y: 0)
    @Previewable @State var optimizeType: OptimizeType = .none

    OptimizeView(
        sector: game[coord]!,
        optimizeType: $optimizeType
    )
}
