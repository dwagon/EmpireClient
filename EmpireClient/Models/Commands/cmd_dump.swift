//
//  Dump.swift
//  EmpireClient
//
//  Created by Dougal Scott on 26/7/2026.
//

// Sun Jul 26 13:19:31 2026
// DUMP SECTOR 1785035971
// x y des sdes eff mob * off min gold fert ocontent uran work avail terr civ mil uw food shell ...
//    gun pet iron dust bar oil lcm hcm rad u_del f_del s_del g_del p_del i_del d_del b_del o_del ...
//    l_del h_del r_del u_cut f_cut s_cut g_cut p_cut i_cut d_cut b_cut o_cut l_cut h_cut r_cut ...
//    dist_x dist_y c_dist m_dist u_dist f_dist s_dist g_dist p_dist i_dist d_dist b_dist o_dist ...
//    l_dist h_dist r_dist road rail defense fallout coast c_del m_del c_cut m_cut terr1 terr2 terr3
// 0 0 c _ 100 127 . 0 100 100 100 100 100 100 0 0 1000 55 75 0 0 0 0 0 0 0 0 0 0 0 . . . . . . . . . . . .
//    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 100 0 0 . . 0 0 0 0 0
// 2 0 c _ 100 127 . 0 100 100 100 100 100 100 0 0 1000 55 75 0 0 0 0 0 0 0 0 0 0 0 . . . . . . . . . . . .
//    0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 100 0 0 . . 0 0 0 0 0
// 2 sectors

import Foundation
import HexGrid

extension Game {
    func cmd_dump() async {
        let result = await client.runCmd("dump *")
        guard result != [] else {
            log("dump returned empty")
            return
        }
        if result.contains("Command dump not found") {
            log("Need to login first")
            return
        }
        if result.contains("\"dump\" is not a legal command") {
            log("Need to break sanctuary before running dump")
            return
        }
        parse_cmd_dump(result)
    }

    func parse_cmd_dump(_ input: [String]) {
        var sector: Sector

        for line in input[3..<input.count - 1] {
            let bits = line.split(separator: " ")
            let coord = MapCoord(x: Int(bits[0])!, y: Int(bits[1])!)
            if self[coord] == nil {
                self[coord] = Sector(coords: coord)
            }
            sector = self[coord]!
            sector.owned = true
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
            sector.cargo[.civ] = Int(bits[16])
            sector.cargo[.mil] = Int(bits[17])
            sector.cargo[.uw] = Int(bits[18])
            sector.cargo[.food] = Int(bits[19])
            sector.cargo[.shells] = Int(bits[20])
            sector.cargo[.guns] = Int(bits[21])
            sector.cargo[.petrol] = Int(bits[22])
            sector.cargo[.ironOre] = Int(bits[23])
            sector.cargo[.goldDust] = Int(bits[24])
            sector.cargo[.goldBars] = Int(bits[25])
            sector.cargo[.oil] = Int(bits[26])
            sector.cargo[.lcm] = Int(bits[27])
            sector.cargo[.hcm] = Int(bits[28])
            sector.cargo[.radioactives] = Int(bits[29])
            sector.deliver[.uw] = String(bits[30])  // u_del
            sector.deliver[.food] = String(bits[31])
            sector.deliver[.shells] = String(bits[32])
            sector.deliver[.guns] = String(bits[33])
            sector.deliver[.petrol] = String(bits[34])
            sector.deliver[.ironOre] = String(bits[35])
            sector.deliver[.goldDust] = String(bits[36])
            sector.deliver[.goldBars] = String(bits[37])
            sector.deliver[.oil] = String(bits[38])
            sector.deliver[.lcm] = String(bits[39])
            sector.deliver[.hcm] = String(bits[40])
            sector.deliver[.radioactives] = String(bits[41])
            sector.cutoff[.uw] = Int(bits[42])       // u_cut
            sector.cutoff[.food] = Int(bits[43])
            sector.cutoff[.shells] = Int(bits[44])
            sector.cutoff[.guns] = Int(bits[45])
            sector.cutoff[.petrol] = Int(bits[46])
            sector.cutoff[.ironOre] = Int(bits[47])
            sector.cutoff[.goldDust] = Int(bits[48])
            sector.cutoff[.goldBars] = Int(bits[49])
            sector.cutoff[.oil] = Int(bits[50])
            sector.cutoff[.lcm] = Int(bits[51])
            sector.cutoff[.hcm] = Int(bits[52])
            sector.cutoff[.radioactives] = Int(bits[53])
            sector[.distX] = MapKeyValue(bits[54])
            sector[.distY] = MapKeyValue(bits[55])
            sector.distribute[.civ] = Int(bits[56])     // c_dist
            sector.distribute[.mil] = Int(bits[57])
            sector.distribute[.uw] = Int(bits[58])
            sector.distribute[.food] = Int(bits[59])
            sector.distribute[.shells] = Int(bits[60])
            sector.distribute[.guns] = Int(bits[61])
            sector.distribute[.petrol] = Int(bits[62])
            sector.distribute[.ironOre] = Int(bits[63])
            sector.distribute[.goldDust] = Int(bits[64])
            sector.distribute[.goldBars] = Int(bits[65])
            sector.distribute[.oil] = Int(bits[66])
            sector.distribute[.lcm] = Int(bits[67])
            sector.distribute[.hcm] = Int(bits[68])
            sector.distribute[.radioactives] = Int(bits[69])
            sector[.road] = MapKeyValue(bits[70])
            sector[.rail] = MapKeyValue(bits[71])
            sector[.defence] = MapKeyValue(bits[72])
            sector[.fallout] = MapKeyValue(bits[73])
            sector[.coast] = MapKeyValue(bits[74])
            sector.deliver[.civ] = String(bits[75])
            sector.deliver[.mil] = String(bits[76])
            sector.cutoff[.civ] = Int(bits[77])
            sector.cutoff[.mil] = Int(bits[78])
            sector[.terr1] = MapKeyValue(bits[79])
            sector[.terr2] = MapKeyValue(bits[80])
            sector[.terr3] = MapKeyValue(bits[81])
        }
    }
}
