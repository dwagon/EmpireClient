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
    let maxUnits = 20

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
                case .ship: buildShipDetails
                case .plane: buildPlaneDetails
                case .land: buildLandUnitDetails
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

    var buildShipDetails: some View {
        return VStack {
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
                    Text("\(game[coord]!.cargo[.lcm], default: "?")")
                    Text("\(game[coord]!.cargo[.hcm], default: "?")")
                    Text("\(game[coord]![.avail], default: "?")")
                    Text("$\(game.treasury)")
                }
                GridRow {
                    Text("Requirement")
                    let lcmCost =
                        game.shipTypes[deviceType] != nil
                        ? game.shipTypes[deviceType]!.lcmCost * number : 0
                    let hcmCost =
                        game.shipTypes[deviceType] != nil
                        ? game.shipTypes[deviceType]!.hcmCost * number : 0
                    let avail =
                        game.shipTypes[deviceType] != nil
                        ? game.shipTypes[deviceType]!.avail * number : 0
                    let cost =
                        game.shipTypes[deviceType] != nil
                        ? game.shipTypes[deviceType]!.cost * number : 0
                    Text("\(lcmCost)")
                    Text("\(hcmCost)")
                    Text("\(avail)")
                    Text("$\(cost)")
                }
            }
            HStack {
                Picker("Ship Type to Build", selection: $deviceType) {
                    Text("No ship").tag("")
                    ForEach(
                        Array(game.shipTypes.keys).filter({
                            game.isShipBuildable($0)
                        }),
                        id: \.self
                    ) { shipType in
                        let details = game.shipTypes[shipType]!
                        Text("\(details.name)").tag(shipType)
                    }
                }.pickerStyle(.menu)
                Spacer()
                Picker("Number to Build", selection: $number) {
                    ForEach(0...maxUnits, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
            }
        }
    }

    var buildPlaneDetails: some View {
        return VStack {
            Grid(alignment: .leading) {
                GridRow {
                    Text("")
                    Text("LCM")
                    Text("HCM")
                    Text("Crew")
                    Text("Avail")
                    Text("Cost")
                }
                GridRow {
                    Text("Available")
                    Text("\(game[coord]!.cargo[.lcm], default: "?")")
                    Text("\(game[coord]!.cargo[.hcm], default: "?")")
                    Text("\(game[coord]!.cargo[.mil], default: "?")")
                    Text("\(game[coord]![.avail], default: "?")")
                    Text("$\(game.treasury)")
                }
                GridRow {
                    Text("Requirement")
                    let lcmCost =
                        game.planeTypes[deviceType] != nil
                        ? game.planeTypes[deviceType]!.lcmCost * number : 0
                    let hcmCost =
                        game.planeTypes[deviceType] != nil
                        ? game.planeTypes[deviceType]!.hcmCost * number : 0
                    let crewCost =
                        game.planeTypes[deviceType] != nil
                        ? game.planeTypes[deviceType]!.crewCost * number : 0
                    let avail =
                        game.planeTypes[deviceType] != nil
                        ? game.planeTypes[deviceType]!.avail * number : 0
                    let cost =
                        game.planeTypes[deviceType] != nil
                        ? game.planeTypes[deviceType]!.cost * number : 0
                    Text("\(lcmCost)")
                    Text("\(hcmCost)")
                    Text("\(crewCost)")
                    Text("\(avail)")
                    Text("$\(cost)")
                }
            }
            HStack {
                Picker("Plane Type to Build", selection: $deviceType) {
                    Text("No plane").tag("")
                    ForEach(Array(game.planeTypes.keys), id: \.self) {
                        planeType in

                        let details = game.planeTypes[planeType]!
                        Text("\(details.name)").tag(planeType)
                    }
                }.pickerStyle(.menu)
                Spacer()
                Picker("Number to Build", selection: $number) {
                    ForEach(0...maxUnits, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
            }
        }
    }

    var buildLandUnitDetails: some View {
        return VStack {
            Grid(alignment: .leading) {
                GridRow {
                    Text("")
                    Text("LCM")
                    Text("HCM")
                    Text("Gun")
                    Text("Avail")
                    Text("Cost")
                }
                GridRow {
                    Text("Available")
                    Text("\(game[coord]!.cargo[.lcm], default: "?")")
                    Text("\(game[coord]!.cargo[.hcm], default: "?")")
                    Text("\(game[coord]!.cargo[.guns], default: "?")")
                    Text("\(game[coord]![.avail], default: "?")")
                    Text("$\(game.treasury)")
                }
                GridRow {
                    Text("Requirement")
                    let lcmCost =
                        game.landTypes[deviceType] != nil
                        ? game.landTypes[deviceType]!.lcmCost * number : 0
                    let hcmCost =
                        game.landTypes[deviceType] != nil
                        ? game.landTypes[deviceType]!.hcmCost * number : 0
                    let gunCost =
                        game.landTypes[deviceType] != nil
                        ? game.landTypes[deviceType]!.gunCost * number : 0
                    let avail =
                        game.landTypes[deviceType] != nil
                        ? game.landTypes[deviceType]!.avail * number : 0
                    let cost =
                        game.landTypes[deviceType] != nil
                        ? game.landTypes[deviceType]!.cost * number : 0
                    Text("\(lcmCost)")
                    Text("\(hcmCost)")
                    Text("\(gunCost)")
                    Text("\(avail)")
                    Text("$\(cost)")
                }
            }
            HStack {
                Picker("Unit Type to Build", selection: $deviceType) {
                    Text("No unit").tag("")
                    ForEach(
                        Array(game.landTypes.keys),
                        id: \.self
                    ) { unitType in
                        let details = game.landTypes[unitType]!
                        Text("\(details.name)").tag(unitType)
                    }
                }.pickerStyle(.menu)
                Spacer()
                Picker("Number to Build", selection: $number) {
                    ForEach(0...maxUnits, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
            }
        }
    }

}

/// Call out to build the thing
func buildThing(game: Game, number: Int, type: String, coord: MapCoord) {
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
            switch device {
            case .ship:
                await game.cmd_sdump()
            case .land:
                await game.cmd_ldump()
            case .plane:
                await game.cmd_pdump()
            default:
                break
            }
        }
    }
}

struct BuildSheet: ViewModifier {
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
                buildThing(game: game, number: number, type: type, coord: coord)
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
        centerCoord: MapCoord
    ) -> some View {
        modifier(
            BuildSheet(
                isPresented: isPresented,
                game: game,
                coord: centerCoord
            )
        )
    }
}

// #Preview("Ship") {
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
// }
