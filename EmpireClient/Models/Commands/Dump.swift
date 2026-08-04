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

        for line in result[3..<result.count-1] {
            let bits = line.split(separator: " ")
            let coord = MapCoord(x: Int(bits[0])!, y: Int(bits[1])!)
            do {
                sector = try game_map.sector(coord)
            } catch {
                print("cmd_dump() Couldn't find cell at \(coord)")
                continue
            }
            sector[.desig] = String(bits[2])
            sector[.sdes] = String(bits[3])
            sector[.eff] = Int(bits[4])
            sector[.mob] = Int(bits[5])
            sector[.min] = Int(bits[8])
            sector[.gold] = Int(bits[9])
            sector[.fert] = Int(bits[10])
            sector[.ocontent] = Int(bits[11])
            sector[.uran] = Int(bits[12])
            sector[.work] = Int(bits[13])
            sector[.avail] = Int(bits[14])
            sector[.terr] = Int(bits[15])
            sector[.civ] = Int(bits[16])
            sector[.mil] = Int(bits[17])
            sector[.uw] = Int(bits[18])
            sector[.food] = Int(bits[19])
            sector[.shell] = Int(bits[20])
            sector[.gun] = Int(bits[21])
            sector[.pet] = Int(bits[22])
            sector[.iron] = Int(bits[23])
            sector[.dust] = Int(bits[24])
            sector[.bar] = Int(bits[25])
            sector[.oil] = Int(bits[26])
            sector[.lcm] = Int(bits[27])
            sector[.hcm] = Int(bits[28])
            sector[.rad] = Int(bits[29])
            sector[.u_del] = String(bits[30])
            sector[.f_del] = String(bits[31])
            sector[.s_del] = String(bits[32])
            sector[.g_del] = String(bits[33])
            sector[.p_del] = String(bits[34])
            sector[.i_del] = String(bits[35])
            sector[.d_del] = String(bits[36])
            sector[.b_del] = String(bits[37])
            sector[.o_del] = String(bits[38])
            sector[.l_del] = String(bits[39])
            sector[.h_del] = String(bits[40])
            sector[.r_del] = String(bits[41])
            sector[.u_cut] = Int(bits[42])
            sector[.f_cut] = Int(bits[43])
            sector[.s_cut] = Int(bits[44])
            sector[.g_cut] = Int(bits[45])
            sector[.p_cut] = Int(bits[46])
            sector[.i_cut] = Int(bits[47])
            sector[.d_cut] = Int(bits[48])
            sector[.b_cut] = Int(bits[49])
            sector[.o_cut] = Int(bits[50])
            sector[.l_cut] = Int(bits[51])
            sector[.h_cut] = Int(bits[52])
            sector[.r_cut] = Int(bits[53])
            sector[.dist_x] = Int(bits[54])
            sector[.dist_y] = Int(bits[55])
            sector[.c_dist] = Int(bits[56])
            sector[.m_dist] = Int(bits[57])
            sector[.u_dist] = Int(bits[58])
            sector[.f_dist] = Int(bits[59])
            sector[.s_dist] = Int(bits[60])
            sector[.g_dist] = Int(bits[61])
            sector[.p_dist] = Int(bits[62])
            sector[.i_dist] = Int(bits[63])
            sector[.d_dist] = Int(bits[64])
            sector[.b_dist] = Int(bits[65])
            sector[.o_dist] = Int(bits[66])
            sector[.l_dist] = Int(bits[67])
            sector[.h_dist] = Int(bits[68])
            sector[.r_dist] = Int(bits[69])
            sector[.road] = Int(bits[70])
            sector[.rail] = Int(bits[71])
            sector[.defence] = Int(bits[72])
            sector[.fallout] = Int(bits[73])
            sector[.coast] = Int(bits[74])
            sector[.c_del] = String(bits[75])
            sector[.m_del] = String(bits[76])
            sector[.c_cut] = Int(bits[77])
            sector[.m_cut] = Int(bits[78])
            sector[.terr1] = Int(bits[79])
            sector[.terr2] = Int(bits[80])
            sector[.terr3] = Int(bits[81])
        }
    }
}
