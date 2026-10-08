//
//  BuildView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 25/8/2026.
//

import SwiftUI

struct BuildView: View {
    let game: Game
    let sector: Sector
    @Binding var viewMode: SectorViewMode

    @State var buildType: BuildType
    @State var maxUnits = 20
    @State var deviceType: String
    @State var number: Int

    init(game: Game, sector: Sector, viewMode: Binding<SectorViewMode>) {
        self.game = game
        self.sector = sector
        self._viewMode = viewMode
        self.buildType = getBuildType(sector.desig.desig)
        self.deviceType = ""
        self.number = 1
    }

    var body: some View {
        VStack {
            Label(
                "Build at \(sector.coords.toString())",
                systemImage: "wrench.and.screwdriver"
            ).font(.title)
            HStack {
                switch buildType {
                case .ship: buildShipDetails
                case .plane: buildPlaneDetails
                case .land: buildLandUnitDetails
                case .nuke: buildNukeDetails
                default:
                    Text("Unknown \(buildType.name)")
                }
            }.padding()
            HStack {
                CancelButton() {
                    viewMode = .overview
                }
                OkButton("Build") {
                    buildThing(game: game, number: number, device: buildType, type: deviceType, sector: sector)
                    viewMode = .overview
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
                    Text("\(sector.cargo[.lcm], default: "?")")
                    Text("\(sector.cargo[.hcm], default: "?")")
                    Text("\(sector[.avail], default: "?")")
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
                            game.shipTypes[$0]!.isBuildable(
                                techlevel: game.techLevel
                            )
                        }).sorted(by: {
                            game.shipTypes[$0]!.abbrev
                                < game.shipTypes[$1]!.abbrev
                        }),
                        id: \.self
                    ) { shipType in
                        let details = game.shipTypes[shipType]!
                        Text("\(details.name) (\(details.abbrev))").tag(
                            shipType
                        )
                    }
                }.pickerStyle(.menu)
                    .padding()
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
                    Text("\(sector.cargo[.lcm], default: "?")")
                    Text("\(sector.cargo[.hcm], default: "?")")
                    Text("\(sector.cargo[.mil], default: "?")")
                    Text("\(sector[.avail], default: "?")")
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

                    ForEach(
                        Array(game.planeTypes.keys).sorted(by: {
                            game.planeTypes[$0]!.abbrev
                                < game.planeTypes[$1]!.abbrev
                        }),
                        id: \.self
                    ) { planeType in
                        let details = game.planeTypes[planeType]!
                        Text("\(details.name) (\(details.abbrev))").tag(
                            planeType
                        )
                    }
                }.pickerStyle(.menu).padding()
                            Picker("Number to Build", selection: $number) {
                    ForEach(0...maxUnits, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
            }
        }
    }

    var buildNukeDetails: some View {
        return VStack {
            Grid(alignment: .leading) {
                GridRow {
                    Text("")
                    Text("LCM")
                    Text("HCM")
                    Text("Oil")
                    Text("Rads")
                    Text("Avail")
                    Text("Cost")
                }
                GridRow {
                    Text("Available")
                    Text("\(sector.cargo[.lcm], default: "?")")
                    Text("\(sector.cargo[.hcm], default: "?")")
                    Text("\(sector.cargo[.oil], default: "?")")
                    Text("\(sector.cargo[.radioactives], default: "?")")
                    Text("\(sector[.avail], default: "?")")
                    Text("$\(game.treasury)")
                }
                GridRow {
                    Text("Requirement")
                    let lcmCost =
                        game.nukeTypes[deviceType] != nil
                        ? game.nukeTypes[deviceType]!.lcmCost * number : 0
                    let hcmCost =
                        game.nukeTypes[deviceType] != nil
                        ? game.nukeTypes[deviceType]!.hcmCost * number : 0
                    let oilCost =
                        game.nukeTypes[deviceType] != nil
                        ? game.nukeTypes[deviceType]!.oilCost * number : 0
                    let radCost =
                        game.nukeTypes[deviceType] != nil
                        ? game.nukeTypes[deviceType]!.radCost * number : 0
                    let avail =
                        game.nukeTypes[deviceType] != nil
                        ? game.nukeTypes[deviceType]!.avail * number : 0
                    let cost =
                        game.nukeTypes[deviceType] != nil
                        ? game.nukeTypes[deviceType]!.cost * number : 0
                    Text("\(lcmCost)")
                    Text("\(hcmCost)")
                    Text("\(oilCost)")
                    Text("\(radCost)")
                    Text("\(avail)")
                    Text("$\(cost)")
                }
            }
            HStack {
                Picker("Nuke Type to Build", selection: $deviceType) {
                    Text("No nuke").tag("")

                    ForEach(
                        Array(game.nukeTypes.keys).sorted(by: {
                            game.nukeTypes[$0]!.abbrev
                                < game.nukeTypes[$1]!.abbrev
                        }),
                        id: \.self
                    ) { nukeType in
                        let details = game.nukeTypes[nukeType]!
                        Text("\(details.name) (\(details.abbrev))").tag(
                            nukeType
                        )
                    }
                }.pickerStyle(.menu).padding()
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
                    Text("\(sector.cargo[.lcm], default: "?")")
                    Text("\(sector.cargo[.hcm], default: "?")")
                    Text("\(sector.cargo[.guns], default: "?")")
                    Text("\(sector[.avail], default: "?")")
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
                        Array(game.landTypes.keys).sorted(by: {
                            game.landTypes[$0]!.abbrev
                                < game.landTypes[$1]!.abbrev
                        }),
                        id: \.self
                    ) { unitType in
                        let details = game.landTypes[unitType]!
                        Text("\(details.name) (\(details.abbrev))").tag(
                            unitType
                        )
                    }
                }.pickerStyle(.menu).padding()
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
func buildThing(
    game: Game,
    number: Int,
    device: BuildType,
    type: String,
    sector: Sector
) {
    Task {
        if number != 0 && type != "" {
            await game.cmd_build(
                device: device,
                type: type,
                sector: sector.coords,
                number: number
            )
            switch device {
            case .ship:
                await game.cmd_sdump()
            case .land:
                await game.cmd_ldump()
            case .plane:
                await game.cmd_pdump()
            case .nuke:
                await game.cmd_ndump()
            default:
                break
            }
        }
        await game.cmd_dump(sector.coords)
    }
}

/// Return what you can build at this desig
func getBuildType(_ desigType: DesigType) -> BuildType {
    var buildType: BuildType = .nothing
    switch desigType {
    case .harbor:
        buildType = .ship
    case .airfield:
        buildType = .plane
    case .headquarters:
        buildType = .land
    case .nuclearPlant:
        buildType = .nuke
    default:
        buildType = .nothing
    }
    return buildType
}
