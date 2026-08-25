//
//  BuildView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 25/8/2026.
//

import SwiftUI

struct BuildView: View {
    let game: Game
    let coord: MapCoord
    let buildType: BuildType
    @Binding var deviceType: String
    @Binding var number: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Label(
                "Build at \(coord.toString())",
                systemImage: "wrench.and.screwdriver"
            ).font(.title)
            HStack {
                switch buildType {
                case .ship: BuildShipDetails
                case .plane: BuildPlaneDetails
                case .land: BuildLandUnitDetails
                default:
                    Text("Unknown \(buildType.name)")
                }

            }.padding()
            HStack {
                Button("Cancel", role: .cancel) {
                    number = 0
                    dismiss()
                }
                .buttonStyle(.automatic)
                .padding()
                Button("Build") {
                    dismiss()
                }
            }
        }
    }

    var BuildShipDetails: some View {
        return VStack {
            Group {
                Grid(alignment: .leading) {
                    GridRow {
                        Text("")
                        Text("LCM")
                        Text("HCM")
                        Text("Avail")
                        Text("Cost")
                    }
                    GridRow {
                        Text("Available")
                        Text("\(game[coord]![.lcm], default: "?")")
                        Text("\(game[coord]![.hcm], default: "?")")
                        Text("\(game[coord]![.avail], default: "?")")
                        Text("TODO")
                    }
                    GridRow {
                        Text("Requirement")
                        let lcm_cost = game.shipTypes[deviceType] != nil ? game.shipTypes[deviceType]!.lcm_cost * number : 0
                        let hcm_cost = game.shipTypes[deviceType] != nil ? game.shipTypes[deviceType]!.hcm_cost * number : 0
                        let avail = game.shipTypes[deviceType] != nil ? game.shipTypes[deviceType]!.avail * number : 0
                        let cost = game.shipTypes[deviceType] != nil ? game.shipTypes[deviceType]!.cost * number : 0

                        Text("\(lcm_cost)")
                        Text("\(hcm_cost)")
                        Text("\(avail)")
                        Text("$\(cost)")
                    }
                }
            }
            HStack {
                Picker("Ship Type to Build", selection: $deviceType) {
                    Text("No ship").tag("")
                    ForEach(Array(game.shipTypes.keys), id: \.self) {
                        shipType in
                        let details = game.shipTypes[shipType]!
                        Text("\(details.name)").tag(shipType)
                    }
                }.pickerStyle(.menu)
                Spacer()
                Picker("Number to Build", selection: $number) {
                    ForEach(0...10, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
            }
        }
    }

    var BuildPlaneDetails: some View {
        return VStack {
            Text("Unimplemented Plane")
        }
    }

    var BuildLandUnitDetails: some View {
        return VStack {
            Text("Unimplemented Landunit")
        }
    }

}

struct View_Build: ViewModifier {
    @Binding var isPresented: Bool
    var game: Game
    var coord: MapCoord
    @State var type: String = ""
    @State var number: Int = 1

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented
            ) {
                isPresented = false
                Task {
                    var device: BuildType
                    if number != 0 && type != "" {
                        switch game[coord]!.desig.desig {
                        case .harbor:
                            device = .ship
                        case .airfield:
                            device = .plane
                        case .headquarters:
                            device = .land
                        default:
                            return
                        }
                        await game.cmd_build(
                            device: device,
                            type: type,
                            sector: coord,
                            number: number
                        )
                    }
                }
            } content: {
                switch game[coord]!.desig.desig {
                case .harbor:
                    BuildView(
                        game: game,
                        coord: coord,
                        buildType: .ship,
                        deviceType: $type,
                        number: $number
                    )
                case .airfield:
                    BuildView(
                        game: game,
                        coord: coord,
                        buildType: .plane,
                        deviceType: $type,
                        number: $number
                    )
                case .headquarters:
                    BuildView(
                        game: game,
                        coord: coord,
                        buildType: .land,
                        deviceType: $type,
                        number: $number
                    )
                default:
                    let _ = game.log(
                        "Unimplemented build at \(game[coord]!.desig.name)"
                    )
                    EmptyView()
                }
            }
    }
}

extension View {
    func build(
        isPresented: Binding<Bool>,
        game: Game,
        center_coord: MapCoord
    ) -> some View {
        modifier(
            View_Build(
                isPresented: isPresented,
                game: game,
                coord: center_coord
            )
        )
    }
}

//#Preview("Ship") {
//
//    @Previewable @State var deviceType: String = ""
//    @Previewable @State var number: Int = 1
//    let game = Game()
//    let coord = MapCoord(x: 0, y: 0)
//    BuildView(
//        game: game,
//        coord: coord,
//        buildType: .ship,
//        deviceType: $deviceType,
//        number: $number
//    )
//}
