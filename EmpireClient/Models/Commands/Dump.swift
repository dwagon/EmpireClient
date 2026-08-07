//
//  Dump.swift
//  EmpireClient
//
//  Created by Dougal Scott on 26/7/2026.
//

//Sun Jul 26 13:19:31 2026
//DUMP SECTOR 1785035971
//x y des sdes eff mob * off min gold fert ocontent uran work avail terr civ mil uw food shell gun pet iron dust bar oil lcm hcm rad u_del f_del s_del g_del p_del i_del d_del b_del o_del l_del h_del r_del u_cut f_cut s_cut g_cut p_cut i_cut d_cut b_cut o_cut l_cut h_cut r_cut dist_x dist_y c_dist m_dist u_dist f_dist s_dist g_dist p_dist i_dist d_dist b_dist o_dist l_dist h_dist r_dist road rail defense fallout coast c_del m_del c_cut m_cut terr1 terr2 terr3
//0 0 c _ 100 127 . 0 100 100 100 100 100 100 0 0 1000 55 75 0 0 0 0 0 0 0 0 0 0 0 . . . . . . . . . . . . 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 100 0 0 . . 0 0 0 0 0
//2 0 c _ 100 127 . 0 100 100 100 100 100 100 0 0 1000 55 75 0 0 0 0 0 0 0 0 0 0 0 . . . . . . . . . . . . 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 100 0 0 . . 0 0 0 0 0
//2 sectors

import Foundation
import HexGrid

extension Game {
    func cmd_dump() async {
        let result = await client.run_cmd("dump #")
        guard result != [] else { return }
        var sector: Sector
        print("result=\(result)")

        for line in result[3..<result.count-1] {
            let bits = line.split(separator: " ")
            let coord = MapCoord(x: Int(bits[0])!, y: Int(bits[1])!)
            if self[coord] == nil {
                self[coord] = Sector(coords: coord)
            }
            sector = self[coord]!
            sector.desig = Desig(String(bits[2]))
            sector.sdes = Desig(String(bits[3]))
            sector[.eff] = MapKeyValue(bits[4])
            sector[.mob] = MapKeyValue(bits[5])
            sector[.min] = MapKeyValue(bits[8])
            sector[.gold] = MapKeyValue(bits[9])
            sector[.fert] = MapKeyValue(bits[10])
            sector[.ocontent] = MapKeyValue(bits[11])
            sector[.uran] = MapKeyValue(bits[12])
            sector[.work] = MapKeyValue(bits[13])
            sector[.avail] = MapKeyValue(bits[14])
            sector[.terr] = MapKeyValue(bits[15])
            sector[.civ] = MapKeyValue(bits[16])
            sector[.mil] = MapKeyValue(bits[17])
            sector[.uw] = MapKeyValue(bits[18])
            sector[.food] = MapKeyValue(bits[19])
            sector[.shell] = MapKeyValue(bits[20])
            sector[.gun] = MapKeyValue(bits[21])
            sector[.pet] = MapKeyValue(bits[22])
            sector[.iron] = MapKeyValue(bits[23])
            sector[.dust] = MapKeyValue(bits[24])
            sector[.bar] = MapKeyValue(bits[25])
            sector[.oil] = MapKeyValue(bits[26])
            sector[.lcm] = MapKeyValue(bits[27])
            sector[.hcm] = MapKeyValue(bits[28])
            sector[.rad] = MapKeyValue(bits[29])
            sector[.u_del] = MapKeyValue(bits[30])
            sector[.f_del] = MapKeyValue(bits[31])
            sector[.s_del] = MapKeyValue(bits[32])
            sector[.g_del] = MapKeyValue(bits[33])
            sector[.p_del] = MapKeyValue(bits[34])
            sector[.i_del] = MapKeyValue(bits[35])
            sector[.d_del] = MapKeyValue(bits[36])
            sector[.b_del] = MapKeyValue(bits[37])
            sector[.o_del] = MapKeyValue(bits[38])
            sector[.l_del] = MapKeyValue(bits[39])
            sector[.h_del] = MapKeyValue(bits[40])
            sector[.r_del] = MapKeyValue(bits[41])
            sector[.u_cut] = MapKeyValue(bits[42])
            sector[.f_cut] = MapKeyValue(bits[43])
            sector[.s_cut] = MapKeyValue(bits[44])
            sector[.g_cut] = MapKeyValue(bits[45])
            sector[.p_cut] = MapKeyValue(bits[46])
            sector[.i_cut] = MapKeyValue(bits[47])
            sector[.d_cut] = MapKeyValue(bits[48])
            sector[.b_cut] = MapKeyValue(bits[49])
            sector[.o_cut] = MapKeyValue(bits[50])
            sector[.l_cut] = MapKeyValue(bits[51])
            sector[.h_cut] = MapKeyValue(bits[52])
            sector[.r_cut] = MapKeyValue(bits[53])
            sector[.dist_x] = MapKeyValue(bits[54])
            sector[.dist_y] = MapKeyValue(bits[55])
            sector[.c_dist] = MapKeyValue(bits[56])
            sector[.m_dist] = MapKeyValue(bits[57])
            sector[.u_dist] = MapKeyValue(bits[58])
            sector[.f_dist] = MapKeyValue(bits[59])
            sector[.s_dist] = MapKeyValue(bits[60])
            sector[.g_dist] = MapKeyValue(bits[61])
            sector[.p_dist] = MapKeyValue(bits[62])
            sector[.i_dist] = MapKeyValue(bits[63])
            sector[.d_dist] = MapKeyValue(bits[64])
            sector[.b_dist] = MapKeyValue(bits[65])
            sector[.o_dist] = MapKeyValue(bits[66])
            sector[.l_dist] = MapKeyValue(bits[67])
            sector[.h_dist] = MapKeyValue(bits[68])
            sector[.r_dist] = MapKeyValue(bits[69])
            sector[.road] = MapKeyValue(bits[70])
            sector[.rail] = MapKeyValue(bits[71])
            sector[.defence] = MapKeyValue(bits[72])
            sector[.fallout] = MapKeyValue(bits[73])
            sector[.coast] = MapKeyValue(bits[74])
            sector[.c_del] = MapKeyValue(bits[75])
            sector[.m_del] = MapKeyValue(bits[76])
            sector[.c_cut] = MapKeyValue(bits[77])
            sector[.m_cut] = MapKeyValue(bits[78])
            sector[.terr1] = MapKeyValue(bits[79])
            sector[.terr2] = MapKeyValue(bits[80])
            sector[.terr3] = MapKeyValue(bits[81])
        }
    }
}
