//
//  HexView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 29/7/2026.
//

import HexGrid
import SwiftUI

struct HexView: View {
    var coord: MapCoord
    var sector: Sector

    @State var resourceCollapse: Bool = false
    @State var naturalResourceCollapse: Bool = false
    @State var populationCollapse: Bool = false

    var desig_str: String {
        var des_str = "Desig: \(sector.desig) (Eff: \(sector[.eff]!)%)"
        if sector.sdes != .unknown {
            des_str += " SDesig: \(sector.sdes)"
        }
        return des_str
    }

    

    var naturalResourceSection: some View {
        Grid {
            GridRow {
                Text("Mine").bold()
                Text("Gold").bold()
                Text("Fertility").bold()
                Text("Oil").bold()
                Text("Uranium").bold()
            }
            Divider()
            GridRow {
                Text(verbatim: "\(sector[.min]!)")
                Text(verbatim: "\(sector[.gold]!)")
                Text(verbatim: "\(sector[.fert]!)")
                Text(verbatim: "\(sector[.ocontent]!)")
                Text(verbatim: "\(sector[.uran]!)")
            }
        }
    }

    var populationSection: some View {
        Grid {
            GridRow {
                Text("Population")
                Text("Civilians")
                Text("Military")
                Text("Uncomp Workers")
            }
            Divider()
            GridRow {
                Text("Amount").bold()
                Text(verbatim: "\(sector[.civ]!)")
                Text(verbatim: "\(sector[.mil]!)")
                Text(verbatim: "\(sector[.uw]!)")
            }
            Divider()
            GridRow {
                Text(verbatim: "Delivery").bold()
                Text(verbatim: "\(sector[.c_del]!)")
                Text(verbatim: "\(sector[.m_del]!)")
                Text(verbatim: "\(sector[.u_del]!)")
            }
            Divider()
            GridRow {
                Text(verbatim: "Cutoff").bold()
                Text(verbatim: "\(sector[.c_cut]!)")
                Text(verbatim: "\(sector[.m_cut]!)")
                Text(verbatim: "\(sector[.u_cut]!)")
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
                Text(verbatim: "\(sector[.food]!)")
                Text(verbatim: "\(sector[.shell]!)")
                Text(verbatim: "\(sector[.gun]!)")
                Text(verbatim: "\(sector[.pet]!)")
                Text(verbatim: "\(sector[.iron]!)")
                Text(verbatim: "\(sector[.dust]!)")
                Text(verbatim: "\(sector[.bar]!)")
                Text(verbatim: "\(sector[.oil]!)")
                Text(verbatim: "\(sector[.lcm]!)")
                Text(verbatim: "\(sector[.hcm]!)")
                Text(verbatim: "\(sector[.rad]!)")
            }
            GridRow {
                Text("Deliver").bold()
                Text(verbatim: "\(sector[.f_del]!)")
                Text(verbatim: "\(sector[.s_del]!)")
                Text(verbatim: "\(sector[.g_del]!)")
                Text(verbatim: "\(sector[.p_del]!)")
                Text(verbatim: "\(sector[.i_del]!)")
                Text(verbatim: "\(sector[.d_del]!)")
                Text(verbatim: "\(sector[.b_del]!)")
                Text(verbatim: "\(sector[.o_del]!)")
                Text(verbatim: "\(sector[.l_del]!)")
                Text(verbatim: "\(sector[.h_del]!)")
                Text(verbatim: "\(sector[.r_del]!)")
            }
            GridRow {
                Text("Distribute").bold()
                Text(verbatim: "\(sector[.f_dist]!)")
                Text(verbatim: "\(sector[.s_dist]!)")
                Text(verbatim: "\(sector[.g_dist]!)")
                Text(verbatim: "\(sector[.p_dist]!)")
                Text(verbatim: "\(sector[.i_dist]!)")
                Text(verbatim: "\(sector[.d_dist]!)")
                Text(verbatim: "\(sector[.b_dist]!)")
                Text(verbatim: "\(sector[.o_dist]!)")
                Text(verbatim: "\(sector[.l_dist]!)")
                Text(verbatim: "\(sector[.h_dist]!)")
                Text(verbatim: "\(sector[.r_dist]!)")
            }
            GridRow {
                Text(verbatim: "Cutoff").bold()
                Text(verbatim: "\(sector[.f_cut]!)")
                Text(verbatim: "\(sector[.s_cut]!)")
                Text(verbatim: "\(sector[.g_cut]!)")
                Text(verbatim: "\(sector[.p_cut]!)")
                Text(verbatim: "\(sector[.i_cut]!)")
                Text(verbatim: "\(sector[.d_cut]!)")
                Text(verbatim: "\(sector[.b_cut]!)")
                Text(verbatim: "\(sector[.o_cut]!)")
                Text(verbatim: "\(sector[.l_cut]!)")
                Text(verbatim: "\(sector[.h_cut]!)")
                Text(verbatim: "\(sector[.r_cut]!)")
            }
        }
    }

    var body: some View {
        List {
            Section {
                Text("Map: \(coord.x), \(coord.y)")
            }
            Section("Sector Details") {
                Text(desig_str)
            }

            //
            Section(isExpanded: $populationCollapse) {
                populationSection
            }
            header: {
                HStack {
                    Text("Population")
                    Spacer()
                    ExpandButton(isExpanded: $populationCollapse)
                }
            }

            //
            Section(isExpanded: $naturalResourceCollapse) {
                naturalResourceSection
            }
            header: {
                HStack {
                    Text("Natural Resources")
                    Spacer()
                    ExpandButton(isExpanded: $naturalResourceCollapse)
                }
            }

            //
            Section(isExpanded: $resourceCollapse) {
                resourceSection
            }
            header: {
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

//#Preview {
//    HexView()
//}
