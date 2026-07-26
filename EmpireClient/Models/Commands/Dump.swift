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
        print("result='\(result)'")
        for line in result[3 ..< result.count] {
            let bits = line.split(separator: " ")
            let coord = MapCoord(x: Int(bits[0])!, y: Int(bits[1])!)
            let cell = game_map.grid.cellAt(coord)
            cell?.attributes["desig"] = Attribute(String(bits[2]))
            cell?.attributes["sdes"] = Attribute(String(bits[3]))
            cell?.attributes["eff"] = Attribute(Int(bits[4]))
            cell?.attributes["mob"] = Attribute(Int(bits[5]))
            cell?.attributes["min"] = Attribute(Int(bits[8]))
            cell?.attributes["gold"] = Attribute(Int(bits[9]))
            cell?.attributes["fert"] = Attribute(Int(bits[10]))
            cell?.attributes["ocontent"] = Attribute(Int(bits[11]))
            cell?.attributes["uran"] = Attribute(Int(bits[12]))
            cell?.attributes["work"] = Attribute(Int(bits[13]))
            cell?.attributes["avail"] = Attribute(Int(bits[14]))
            cell?.attributes["terr"] = Attribute(Int(bits[15]))
            cell?.attributes["civ"] = Attribute(Int(bits[16]))
            cell?.attributes["mil"] = Attribute(Int(bits[17]))
            cell?.attributes["uw"] = Attribute(Int(bits[18]))
            cell?.attributes["food"] = Attribute(Int(bits[19]))
            cell?.attributes["shell"] = Attribute(Int(bits[20]))
            cell?.attributes["gun"] = Attribute(Int(bits[21]))
            cell?.attributes["pet"] = Attribute(Int(bits[22]))
            cell?.attributes["iron"] = Attribute(Int(bits[23]))
            cell?.attributes["dust"] = Attribute(Int(bits[24]))
            cell?.attributes["bar"] = Attribute(Int(bits[25]))
            cell?.attributes["oil"] = Attribute(Int(bits[26]))
            cell?.attributes["lcm"] = Attribute(Int(bits[27]))
            cell?.attributes["hcm"] = Attribute(Int(bits[28]))
            cell?.attributes["rad"] = Attribute(Int(bits[29]))
            cell?.attributes["u_del"] = Attribute(Int(bits[30]))
            cell?.attributes["f_del"] = Attribute(Int(bits[31]))
            cell?.attributes["s_del"] = Attribute(Int(bits[32]))
            cell?.attributes["g_del"] = Attribute(Int(bits[33]))
            cell?.attributes["p_del"] = Attribute(Int(bits[34]))
            cell?.attributes["i_del"] = Attribute(Int(bits[35]))
            cell?.attributes["d_del"] = Attribute(Int(bits[36]))
            cell?.attributes["b_del"] = Attribute(Int(bits[37]))
            cell?.attributes["o_del"] = Attribute(Int(bits[38]))
            cell?.attributes["l_del"] = Attribute(Int(bits[39]))
            cell?.attributes["h_del"] = Attribute(Int(bits[40]))
            cell?.attributes["r_del"] = Attribute(Int(bits[41]))
            cell?.attributes["u_cut"] = Attribute(Int(bits[42]))
            cell?.attributes["f_cut"] = Attribute(Int(bits[43]))
            cell?.attributes["s_cut"] = Attribute(Int(bits[44]))
            cell?.attributes["g_cut"] = Attribute(Int(bits[45]))
            cell?.attributes["p_cut"] = Attribute(Int(bits[46]))
            cell?.attributes["i_cut"] = Attribute(Int(bits[47]))
            cell?.attributes["d_cut"] = Attribute(Int(bits[48]))
            cell?.attributes["b_cut"] = Attribute(Int(bits[49]))
            cell?.attributes["o_cut"] = Attribute(Int(bits[50]))
            cell?.attributes["l_cut"] = Attribute(Int(bits[51]))
            cell?.attributes["h_cut"] = Attribute(Int(bits[52]))
            cell?.attributes["r_cut"] = Attribute(Int(bits[53]))
            cell?.attributes["dist_x"] = Attribute(Int(bits[54]))
            cell?.attributes["dist_y"] = Attribute(Int(bits[55]))
            cell?.attributes["c_dist"] = Attribute(Int(bits[56]))
            cell?.attributes["m_dist"] = Attribute(Int(bits[57]))
            cell?.attributes["u_dist"] = Attribute(Int(bits[58]))
            cell?.attributes["f_dist"] = Attribute(Int(bits[59]))
            cell?.attributes["s_dist"] = Attribute(Int(bits[60]))
            cell?.attributes["g_dist"] = Attribute(Int(bits[61]))
            cell?.attributes["p_dist"] = Attribute(Int(bits[62]))
            cell?.attributes["i_dist"] = Attribute(Int(bits[63]))
            cell?.attributes["d_dist"] = Attribute(Int(bits[64]))
            cell?.attributes["b_dist"] = Attribute(Int(bits[65]))
            cell?.attributes["o_dist"] = Attribute(Int(bits[66]))
            cell?.attributes["l_dist"] = Attribute(Int(bits[67]))
            cell?.attributes["h_dist"] = Attribute(Int(bits[68]))
            cell?.attributes["r_dist"] = Attribute(Int(bits[69]))
            cell?.attributes["road"] = Attribute(Int(bits[70]))
            cell?.attributes["rail"] = Attribute(Int(bits[71]))
            cell?.attributes["defence"] = Attribute(Int(bits[72]))
            cell?.attributes["fallout"] = Attribute(Int(bits[73]))
            cell?.attributes["coast"] = Attribute(Int(bits[74]))
            cell?.attributes["c_del"] = Attribute(Int(bits[75]))
            cell?.attributes["m_del"] = Attribute(Int(bits[76]))
            cell?.attributes["c_cut"] = Attribute(Int(bits[77]))
            cell?.attributes["m_cut"] = Attribute(Int(bits[78]))
            cell?.attributes["terr1"] = Attribute(Int(bits[79]))
            cell?.attributes["terr2"] = Attribute(Int(bits[80]))
            cell?.attributes["terr3"] = Attribute(Int(bits[81]))
        }
    }
}
