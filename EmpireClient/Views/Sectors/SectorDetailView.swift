//
//  SectorDetailView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/8/2026.
//

import SwiftUI

struct SectorDetailView: View {
    var game: Game
    var sector: Sector?

    var desigStr: String {
        var ans: String = "Unknown Sector"
        if let sector {
            ans =
                "Eff: \(sector.eff, default: "?")% -> Est. Eff: \(sector.neweff, default: "?")%"
            if sector.sdes.desig != .unknown {
                ans += " Redesignated to: \(sector.sdes.name)"
            }
        }
        return ans
    }

    var realms: [RealmNum] {
        if let sector {
            return game.inWhichRealm(coord: sector.coords)
        }
        return []
    }

    func resource(_ item: Item) -> some View {
        return Group {
            if let sector {
                if sector.cargo[item] != 0 && sector.cargo[item] != nil {
                    Text(
                        "\(item.rawValue.uppercased()): \(sector.cargo[item], default: "?")"
                    )
                }
            }
        }
    }

    var body: some View {
        HStack {
            VStack {
                if let sector {
                    Text(
                        "\(sector.coords.toString()): \(sector.desig.name)"
                    )
                    .font(.title)
                    //
                    Text(desigStr)
                    HStack {
                        if let distX = sector[.distX],
                            let distY = sector[.distY]
                        {
                            if MapCoord(x: distX, y: distY) != sector.coords {
                                Text(
                                    "Distribute to \(sector[.distX], default: "?"), \(sector[.distY], default: "?")"
                                ).padding(.horizontal)
                            } else {
                                Text("No distribution set").padding(
                                    .horizontal
                                )
                            }
                        }
                        Text("Mobility: \(sector[.mob], default: "?")")
                            .padding(
                                .horizontal
                            )
                        Text(
                            "Available Work: \(sector[.avail], default: "?")"
                        )
                        .padding(.horizontal)
                        Text(
                            realms.isEmpty
                                ? "" : "Realm: \(realms[0], default: "?")"
                        ).padding(.horizontal)
                    }
                    HStack {
                        resource(.civ)
                        resource(.mil)
                        resource(.uw)
                        resource(.food)
                        resource(.shells)
                        resource(.guns)
                        resource(.petrol)
                        resource(.ironOre)
                        resource(.goldDust)
                        resource(.goldBars)
                        resource(.oil)
                        resource(.lcm)
                        resource(.hcm)
                        resource(.radioactives)
                    }
                }
            }
        }
    }
}
