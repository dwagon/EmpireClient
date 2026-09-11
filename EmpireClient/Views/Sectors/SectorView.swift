//
//  HexView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/7/2026.
//

import HexGrid
import SwiftUI

struct SectorView: View {
    var coord: MapCoord
    var sector: Sector

    @State var resourceCollapse: Bool = false
    @State var naturalResourceCollapse: Bool = false
    @State var populationCollapse: Bool = false
    @State var productionCollapse: Bool = false

    var desigStr: String {
        var ans =
            "Desig: \(sector.desig.name) (Eff: \(sector[.eff], default: "??")%)"
        if sector.sdes.desig != .unknown {
            ans += " SDesig: \(sector.sdes.name)"
        }
        return ans
    }

    var naturalResourceSection: some View {
        Grid {
            GridRow {
                Text("Minerals").bold()
                Text("Gold").bold()
                Text("Fertility").bold()
                Text("Oil").bold()
                Text("Uranium").bold()
            }
            Divider()
            GridRow {
                Text(verbatim: "\(sector[.min], default: "?")")
                Text(verbatim: "\(sector[.gold], default: "?")")
                Text(verbatim: "\(sector[.fert], default: "?")")
                Text(verbatim: "\(sector[.ocontent], default: "?")")
                Text(verbatim: "\(sector[.uran], default: "?")")
            }
        }
    }

    var productionSection: some View {
        Grid {
            GridRow {
                Text("Make").bold()
                Text("Prod Eff").bold()
                Text("Cost").bold()
                Text("Max").bold()
                Text("Use 1").bold()
                Text("Use 2").bold()
                Text("Use 3").bold()
            }
            Divider()
            GridRow {
                Text(verbatim: "\(sector[.make], default: "?")")
                Text(verbatim: "\(sector[.prodeff], default: "?")")
                Text(verbatim: "\(sector[.cost], default: "?")")
                Text(verbatim: "\(sector[.max], default: "?")")
                Text(
                    verbatim:
                        "\(sector[.use1], default: "?") / \(sector[.max1], default: "?")"
                )
                Text(
                    verbatim:
                        "\(sector[.use2], default: "?") / \(sector[.max2], default: "?")"
                )
                Text(
                    verbatim:
                        "\(sector[.use3], default: "?") / \(sector[.max3], default: "?")"
                )
            }
        }
    }

    var overviewSection: some View {
        Grid {
            GridRow {
                Text("Civ").bold()
                Text("Mil").bold()
                Text("UW").bold()
                Text("Food").bold()
                Text("Shells").bold()
                Text("Guns").bold()
                Text("Petrol").bold()
                Text("Iron").bold()
                Text("Dust").bold()
                Text("Bars").bold()
                Text("Oil").bold()
                Text("LCM").bold()
                Text("HCM").bold()
                Text("Rad").bold()
            }
            Divider()
            GridRow {
                Text(verbatim: "\(sector.cargo[.civ], default: "?")")
                Text(verbatim: "\(sector.cargo[.mil], default: "?")")
                Text(verbatim: "\(sector.cargo[.uw], default: "?")")
                Text(verbatim: "\(sector.cargo[.food], default: "?")")
                Text(verbatim: "\(sector.cargo[.shells], default: "?")")
                Text(verbatim: "\(sector.cargo[.guns], default: "?")")
                Text(verbatim: "\(sector.cargo[.petrol], default: "?")")
                Text(verbatim: "\(sector.cargo[.ironOre], default: "?")")
                Text(verbatim: "\(sector.cargo[.goldDust], default: "?")")
                Text(verbatim: "\(sector.cargo[.goldBars], default: "?")")
                Text(verbatim: "\(sector.cargo[.oil], default: "?")")
                Text(verbatim: "\(sector.cargo[.lcm], default: "?")")
                Text(verbatim: "\(sector.cargo[.hcm], default: "?")")
                Text(verbatim: "\(sector.cargo[.radioactives], default: "?")")
            }
        }
    }

    var populationSection: some View {
        Grid {
            GridRow() {
                Text("Population").bold()
                Text("Civilians").bold()
                Text("Military").bold()
                Text("Uncomp Workers").bold()
            }
            Divider()
            GridRow {
                Text("Amount").bold()
                Text(verbatim: "\(sector.cargo[.civ], default: "?")")
                Text(verbatim: "\(sector.cargo[.mil], default: "?")")
                Text(verbatim: "\(sector.cargo[.uw], default: "?")")
            }
            Divider()
            GridRow {
                Text(verbatim: "Distribution").bold()
                Text(verbatim: "\(sector.distribute[.civ], default: "?")")
                Text(verbatim: "\(sector.distribute[.mil], default: "?")")
                Text(verbatim: "\(sector.distribute[.uw], default: "?")")
            }
            Divider()
            GridRow {
                Text(verbatim: "Delivery").bold()
                DeliveryDirection(dir: sector.deliver[.civ])
                DeliveryDirection(dir: sector.deliver[.mil])
                DeliveryDirection(dir: sector.deliver[.uw])
            }
            Divider()
            GridRow {
                Text(verbatim: "Cutoff").bold()
                Text(verbatim: "\(sector.cutoff[.civ], default: "?")")
                Text(verbatim: "\(sector.cutoff[.mil], default: "?")")
                Text(verbatim: "\(sector.cutoff[.uw], default: "?")")
            }
        }
    }

    var resourceSection: some View {
        Grid {
            GridRow {
                Text("Resource").bold()
                Text("Food").bold()
                Text("Shells").bold()
                Text("Guns").bold()
                Text("Petrol").bold()
                Text("Iron Ore").bold()
                Text("Gold Dust").bold()
                Text("Gold Bars").bold()
                Text("Crude Oil").bold()
                Text("LCM").bold()
                Text("HCM").bold()
                Text("Rads").bold()
            }
            Divider()
            amountView
            distributeView
            deliverView
            cutOffView
        }
    }

    var amountView: some View {
        GridRow {
            Text("Amount").bold()
            Text(verbatim: "\(sector.cargo[.food], default: "?")")
            Text(verbatim: "\(sector.cargo[.shells], default: "?")")
            Text(verbatim: "\(sector.cargo[.guns], default: "?")")
            Text(verbatim: "\(sector.cargo[.petrol], default: "?")")
            Text(verbatim: "\(sector.cargo[.ironOre], default: "?")")
            Text(verbatim: "\(sector.cargo[.goldDust], default: "?")")
            Text(verbatim: "\(sector.cargo[.goldBars], default: "?")")
            Text(verbatim: "\(sector.cargo[.oil], default: "?")")
            Text(verbatim: "\(sector.cargo[.lcm], default: "?")")
            Text(verbatim: "\(sector.cargo[.hcm], default: "?")")
            Text(verbatim: "\(sector.cargo[.radioactives], default: "?")")
        }
    }

    var deliverView: some View {
        GridRow {
            Text("Deliver").bold()
            DeliveryDirection(dir: sector.deliver[.food])
            DeliveryDirection(dir: sector.deliver[.shells])
            DeliveryDirection(dir: sector.deliver[.guns])
            DeliveryDirection(dir: sector.deliver[.petrol])
            DeliveryDirection(dir: sector.deliver[.ironOre])
            DeliveryDirection(dir: sector.deliver[.goldDust])
            DeliveryDirection(dir: sector.deliver[.goldBars])
            DeliveryDirection(dir: sector.deliver[.oil])
            DeliveryDirection(dir: sector.deliver[.lcm])
            DeliveryDirection(dir: sector.deliver[.hcm])
            DeliveryDirection(dir: sector.deliver[.radioactives])
        }
    }

    var distributeView: some View {
        GridRow {
            Text("Distribute").bold()
            Text(verbatim: "\(sector.distribute[.food], default: "?")")
            Text(verbatim: "\(sector.distribute[.shells], default: "?")")
            Text(verbatim: "\(sector.distribute[.guns], default: "?")")
            Text(verbatim: "\(sector.distribute[.petrol], default: "?")")
            Text(verbatim: "\(sector.distribute[.ironOre], default: "?")")
            Text(verbatim: "\(sector.distribute[.goldDust], default: "?")")
            Text(verbatim: "\(sector.distribute[.goldBars], default: "?")")
            Text(verbatim: "\(sector.distribute[.oil], default: "?")")
            Text(verbatim: "\(sector.distribute[.lcm], default: "?")")
            Text(verbatim: "\(sector.distribute[.hcm], default: "?")")
            Text(verbatim: "\(sector.distribute[.radioactives], default: "?")")
        }
    }

    var cutOffView: some View {
        GridRow {
            Text(verbatim: "Cutoff").bold()
            Text(verbatim: "\(sector.cutoff[.food], default: "?")")
            Text(verbatim: "\(sector.cutoff[.shells], default: "?")")
            Text(verbatim: "\(sector.cutoff[.guns], default: "?")")
            Text(verbatim: "\(sector.cutoff[.petrol], default: "?")")
            Text(verbatim: "\(sector.cutoff[.ironOre], default: "?")")
            Text(verbatim: "\(sector.cutoff[.goldDust], default: "?")")
            Text(verbatim: "\(sector.cutoff[.goldBars], default: "?")")
            Text(verbatim: "\(sector.cutoff[.oil], default: "?")")
            Text(verbatim: "\(sector.cutoff[.lcm], default: "?")")
            Text(verbatim: "\(sector.cutoff[.hcm], default: "?")")
            Text(verbatim: "\(sector.cutoff[.radioactives], default: "?")")
        }
    }

    var body: some View {
        List {
            //
            Section("Sector Details") {
                Text(desigStr)
                if let distX = sector[.distX], let distY = sector[.distY] {
                    if MapCoord(x: distX, y: distY) != coord {
                        Text(
                            "Distribute to \(sector[.distX], default: "?"), \(sector[.distY], default: "?")"
                        )
                    } else {
                        Text("No distribution set")
                    }
                }
                Text("Mobility: \(sector[.mob], default: "?")")
                Text("Available Work: \(sector[.avail], default: "?")")
            }

            //
            Section("Overview") {
                overviewSection
            }
            Spacer()
            //
            Section(isExpanded: $populationCollapse) {
                populationSection
            } header: {
                HStack {
                    Text("Population")
                    Spacer()
                    ExpandButton(isExpanded: $populationCollapse)
                }
            }

            //
            if sector[.make] != nil {
                Section(isExpanded: $productionCollapse) {
                    productionSection
                } header: {
                    HStack {
                        Text("Production")
                        Spacer()
                        ExpandButton(isExpanded: $productionCollapse)
                    }
                }
            }

            //
            Section(isExpanded: $naturalResourceCollapse) {
                naturalResourceSection
            } header: {
                HStack {
                    Text("Natural Resources")
                    Spacer()
                    ExpandButton(isExpanded: $naturalResourceCollapse)
                }
            }

            //
            Section(isExpanded: $resourceCollapse) {
                resourceSection
            } header: {
                HStack {
                    Text("Resources")
                    Spacer()
                    ExpandButton(isExpanded: $resourceCollapse)
                }
            }
        }
    }
}

struct DeliveryDirection: View {
    var dir: String?

    var body: some View {
        if let dir {
            if let icon = directionIcon(dir) {
                Image(systemName: icon)
            }
            else {
                Image(systemName: "questionmark")
            }
        }
        else {
            Image(systemName: "questionmark")
        }
    }
}

struct ExpandButton: View {
    @Binding var isExpanded: Bool

    var body: some View {
        Button(action: {
            withAnimation {
                isExpanded.toggle()
            }
        }) {
            Image(systemName: "chevron.right")
                .rotationEffect(
                    !isExpanded ? Angle(degrees: 0) : Angle(degrees: 90)
                )
        }
        .frame(width: 20, height: 20)
    }
}
