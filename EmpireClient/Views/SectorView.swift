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
                Text(verbatim: "\(sector[.civ], default: "?")")
                Text(verbatim: "\(sector[.mil], default: "?")")
                Text(verbatim: "\(sector[.uw], default: "?")")
                Text(verbatim: "\(sector[.food], default: "?")")
                Text(verbatim: "\(sector[.shell], default: "?")")
                Text(verbatim: "\(sector[.gun], default: "?")")
                Text(verbatim: "\(sector[.petrol], default: "?")")
                Text(verbatim: "\(sector[.iron], default: "?")")
                Text(verbatim: "\(sector[.dust], default: "?")")
                Text(verbatim: "\(sector[.bar], default: "?")")
                Text(verbatim: "\(sector[.oil], default: "?")")
                Text(verbatim: "\(sector[.lcm], default: "?")")
                Text(verbatim: "\(sector[.hcm], default: "?")")
                Text(verbatim: "\(sector[.rad], default: "?")")
            }
        }
    }

    var populationSection: some View {
        Grid {
            GridRow {
                Text("Population").bold()
                Text("Civilians").bold()
                Text("Military").bold()
                Text("Uncomp Workers").bold()
            }
            Divider()
            GridRow {
                Text("Amount").bold()
                Text(verbatim: "\(sector[.civ], default: "?")")
                Text(verbatim: "\(sector[.mil], default: "?")")
                Text(verbatim: "\(sector[.uw], default: "?")")
            }
            Divider()
            GridRow {
                Text(verbatim: "Delivery").bold()
                Text(verbatim: "\(sector[.civDeliver], default: "?")")
                Text(verbatim: "\(sector[.milDeliver], default: "?")")
                Text(verbatim: "\(sector[.uwDeliver], default: "?")")
            }
            Divider()
            GridRow {
                Text(verbatim: "Cutoff").bold()
                Text(verbatim: "\(sector[.civCutoff], default: "?")")
                Text(verbatim: "\(sector[.milCutoff], default: "?")")
                Text(verbatim: "\(sector[.uranCutoff], default: "?")")
            }
            Divider()
            GridRow {
                Text(verbatim: "Distribution").bold()
                Text(verbatim: "\(sector[.civDist], default: "?")")
                Text(verbatim: "\(sector[.milDist], default: "?")")
                Text(verbatim: "\(sector[.uwDist], default: "?")")
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
                Text("Petroleum").bold()
                Text("Iron Ore").bold()
                Text("Gold Dust").bold()
                Text("Gold Bars").bold()
                Text("Crude Oil").bold()
                Text("Light CM").bold()
                Text("Heavy CM").bold()
                Text("Radioactives").bold()
            }
            Divider()
            amountView
            deliverView
            distributeView
            cutOffView
        }
    }

    var amountView: some View {
        GridRow {
            Text("Amount").bold()
            Text(verbatim: "\(sector[.food], default: "?")")
            Text(verbatim: "\(sector[.shell], default: "?")")
            Text(verbatim: "\(sector[.gun], default: "?")")
            Text(verbatim: "\(sector[.petrol], default: "?")")
            Text(verbatim: "\(sector[.iron], default: "?")")
            Text(verbatim: "\(sector[.dust], default: "?")")
            Text(verbatim: "\(sector[.bar], default: "?")")
            Text(verbatim: "\(sector[.oil], default: "?")")
            Text(verbatim: "\(sector[.lcm], default: "?")")
            Text(verbatim: "\(sector[.hcm], default: "?")")
            Text(verbatim: "\(sector[.rad], default: "?")")
        }
    }

    var deliverView: some View {
        GridRow {
            Text("Deliver").bold()
            Text(verbatim: "\(sector[.foodDeliver], default: "?")")
            Text(verbatim: "\(sector[.shellDeliver], default: "?")")
            Text(verbatim: "\(sector[.gunDeliver], default: "?")")
            Text(verbatim: "\(sector[.petrolDeliver], default: "?")")
            Text(verbatim: "\(sector[.ironDeliver], default: "?")")
            Text(verbatim: "\(sector[.dustDeliver], default: "?")")
            Text(verbatim: "\(sector[.barDeliver], default: "?")")
            Text(verbatim: "\(sector[.oilDeliver], default: "?")")
            Text(verbatim: "\(sector[.lcmDeliver], default: "?")")
            Text(verbatim: "\(sector[.hcmDeliver], default: "?")")
            Text(verbatim: "\(sector[.radDeliver], default: "?")")
        }
    }

    var distributeView: some View {
        GridRow {
            Text("Distribute").bold()
            Text(verbatim: "\(sector[.foodDist], default: "?")")
            Text(verbatim: "\(sector[.shellDist], default: "?")")
            Text(verbatim: "\(sector[.gunDist], default: "?")")
            Text(verbatim: "\(sector[.petrolDist], default: "?")")
            Text(verbatim: "\(sector[.ironDist], default: "?")")
            Text(verbatim: "\(sector[.dustDist], default: "?")")
            Text(verbatim: "\(sector[.barDist], default: "?")")
            Text(verbatim: "\(sector[.oilDist], default: "?")")
            Text(verbatim: "\(sector[.lcmDist], default: "?")")
            Text(verbatim: "\(sector[.hcmDist], default: "?")")
            Text(verbatim: "\(sector[.radDist], default: "?")")
        }
    }

    var cutOffView: some View {
        GridRow {
            Text(verbatim: "Cutoff").bold()
            Text(verbatim: "\(sector[.foodCutoff], default: "?")")
            Text(verbatim: "\(sector[.shellCutoff], default: "?")")
            Text(verbatim: "\(sector[.gunCutoff], default: "?")")
            Text(verbatim: "\(sector[.petrolCutoff], default: "?")")
            Text(verbatim: "\(sector[.ironCutoff], default: "?")")
            Text(verbatim: "\(sector[.dustCutoff], default: "?")")
            Text(verbatim: "\(sector[.barCutoff], default: "?")")
            Text(verbatim: "\(sector[.oilCutoff], default: "?")")
            Text(verbatim: "\(sector[.lcmCutoff], default: "?")")
            Text(verbatim: "\(sector[.hcmCutoff], default: "?")")
            Text(verbatim: "\(sector[.radCutoff], default: "?")")
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
