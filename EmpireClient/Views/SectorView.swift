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

    var desig_str: String {
        var des_str =
            "Desig: \(sector.desig.name) (Eff: \(sector[.eff], default: "??")%)"
        if sector.sdes.desig != .unknown {
            des_str += " SDesig: \(sector.sdes.name)"
        }
        return des_str
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
                Text(verbatim: "\(sector[.pet], default: "?")")
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
                Text(verbatim: "\(sector[.c_del], default: "?")")
                Text(verbatim: "\(sector[.m_del], default: "?")")
                Text(verbatim: "\(sector[.u_del], default: "?")")
            }
            Divider()
            GridRow {
                Text(verbatim: "Cutoff").bold()
                Text(verbatim: "\(sector[.c_cut], default: "?")")
                Text(verbatim: "\(sector[.m_cut], default: "?")")
                Text(verbatim: "\(sector[.u_cut], default: "?")")
            }
            Divider()
            GridRow {
                Text(verbatim: "Distribution").bold()
                Text(verbatim: "\(sector[.c_dist], default: "?")")
                Text(verbatim: "\(sector[.m_dist], default: "?")")
                Text(verbatim: "\(sector[.u_dist], default: "?")")
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
            GridRow {
                Text("Amount").bold()
                Text(verbatim: "\(sector[.food], default: "?")")
                Text(verbatim: "\(sector[.shell], default: "?")")
                Text(verbatim: "\(sector[.gun], default: "?")")
                Text(verbatim: "\(sector[.pet], default: "?")")
                Text(verbatim: "\(sector[.iron], default: "?")")
                Text(verbatim: "\(sector[.dust], default: "?")")
                Text(verbatim: "\(sector[.bar], default: "?")")
                Text(verbatim: "\(sector[.oil], default: "?")")
                Text(verbatim: "\(sector[.lcm], default: "?")")
                Text(verbatim: "\(sector[.hcm], default: "?")")
                Text(verbatim: "\(sector[.rad], default: "?")")
            }
            GridRow {
                Text("Deliver").bold()
                Text(verbatim: "\(sector[.f_del], default: "?")")
                Text(verbatim: "\(sector[.s_del], default: "?")")
                Text(verbatim: "\(sector[.g_del], default: "?")")
                Text(verbatim: "\(sector[.p_del], default: "?")")
                Text(verbatim: "\(sector[.i_del], default: "?")")
                Text(verbatim: "\(sector[.d_del], default: "?")")
                Text(verbatim: "\(sector[.b_del], default: "?")")
                Text(verbatim: "\(sector[.o_del], default: "?")")
                Text(verbatim: "\(sector[.l_del], default: "?")")
                Text(verbatim: "\(sector[.h_del], default: "?")")
                Text(verbatim: "\(sector[.r_del], default: "?")")
            }
            GridRow {
                Text("Distribute").bold()
                Text(verbatim: "\(sector[.f_dist], default: "?")")
                Text(verbatim: "\(sector[.s_dist], default: "?")")
                Text(verbatim: "\(sector[.g_dist], default: "?")")
                Text(verbatim: "\(sector[.p_dist], default: "?")")
                Text(verbatim: "\(sector[.i_dist], default: "?")")
                Text(verbatim: "\(sector[.d_dist], default: "?")")
                Text(verbatim: "\(sector[.b_dist], default: "?")")
                Text(verbatim: "\(sector[.o_dist], default: "?")")
                Text(verbatim: "\(sector[.l_dist], default: "?")")
                Text(verbatim: "\(sector[.h_dist], default: "?")")
                Text(verbatim: "\(sector[.r_dist], default: "?")")
            }
            GridRow {
                Text(verbatim: "Cutoff").bold()
                Text(verbatim: "\(sector[.f_cut], default: "?")")
                Text(verbatim: "\(sector[.s_cut], default: "?")")
                Text(verbatim: "\(sector[.g_cut], default: "?")")
                Text(verbatim: "\(sector[.p_cut], default: "?")")
                Text(verbatim: "\(sector[.i_cut], default: "?")")
                Text(verbatim: "\(sector[.d_cut], default: "?")")
                Text(verbatim: "\(sector[.b_cut], default: "?")")
                Text(verbatim: "\(sector[.o_cut], default: "?")")
                Text(verbatim: "\(sector[.l_cut], default: "?")")
                Text(verbatim: "\(sector[.h_cut], default: "?")")
                Text(verbatim: "\(sector[.r_cut], default: "?")")
            }
        }
    }

    var body: some View {
        List {
            //
            Section("Sector Details") {
                Text(desig_str)
                if let dist_x = sector[.dist_x], let dist_y = sector[.dist_y] {
                    if MapCoord(x: dist_x, y: dist_y) != coord {
                        Text(
                            "Distribute to \(sector[.dist_x], default: "?"), \(sector[.dist_y], default: "?")"
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
