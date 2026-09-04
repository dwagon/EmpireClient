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
            sector[.civ] = MapKeyValue(bits[16])
            sector[.mil] = MapKeyValue(bits[17])
            sector[.uw] = MapKeyValue(bits[18])
            sector[.food] = MapKeyValue(bits[19])
            sector[.shell] = MapKeyValue(bits[20])
            sector[.gun] = MapKeyValue(bits[21])
            sector[.petrol] = MapKeyValue(bits[22])
            sector[.iron] = MapKeyValue(bits[23])
            sector[.dust] = MapKeyValue(bits[24])
            sector[.bar] = MapKeyValue(bits[25])
            sector[.oil] = MapKeyValue(bits[26])
            sector[.lcm] = MapKeyValue(bits[27])
            sector[.hcm] = MapKeyValue(bits[28])
            sector[.rad] = MapKeyValue(bits[29])
            sector[.uwDeliver] = MapKeyValue(bits[30])
            sector[.foodDeliver] = MapKeyValue(bits[31])
            sector[.shellDeliver] = MapKeyValue(bits[32])
            sector[.gunDeliver] = MapKeyValue(bits[33])
            sector[.petrolDeliver] = MapKeyValue(bits[34])
            sector[.ironDeliver] = MapKeyValue(bits[35])
            sector[.dustDeliver] = MapKeyValue(bits[36])
            sector[.barDeliver] = MapKeyValue(bits[37])
            sector[.oilDeliver] = MapKeyValue(bits[38])
            sector[.lcmDeliver] = MapKeyValue(bits[39])
            sector[.hcmDeliver] = MapKeyValue(bits[40])
            sector[.radDeliver] = MapKeyValue(bits[41])
            sector[.uranCutoff] = MapKeyValue(bits[42])
            sector[.foodCutoff] = MapKeyValue(bits[43])
            sector[.shellCutoff] = MapKeyValue(bits[44])
            sector[.gunCutoff] = MapKeyValue(bits[45])
            sector[.petrolCutoff] = MapKeyValue(bits[46])
            sector[.ironCutoff] = MapKeyValue(bits[47])
            sector[.dustCutoff] = MapKeyValue(bits[48])
            sector[.barCutoff] = MapKeyValue(bits[49])
            sector[.oilCutoff] = MapKeyValue(bits[50])
            sector[.lcmCutoff] = MapKeyValue(bits[51])
            sector[.hcmCutoff] = MapKeyValue(bits[52])
            sector[.radCutoff] = MapKeyValue(bits[53])
            sector[.distX] = MapKeyValue(bits[54])
            sector[.distY] = MapKeyValue(bits[55])
            sector[.civDist] = MapKeyValue(bits[56])
            sector[.milDist] = MapKeyValue(bits[57])
            sector[.uwDist] = MapKeyValue(bits[58])
            sector[.foodDist] = MapKeyValue(bits[59])
            sector[.shellDist] = MapKeyValue(bits[60])
            sector[.gunDist] = MapKeyValue(bits[61])
            sector[.petrolDist] = MapKeyValue(bits[62])
            sector[.ironDist] = MapKeyValue(bits[63])
            sector[.dustDist] = MapKeyValue(bits[64])
            sector[.barDist] = MapKeyValue(bits[65])
            sector[.oilDist] = MapKeyValue(bits[66])
            sector[.lcmDist] = MapKeyValue(bits[67])
            sector[.hcmDist] = MapKeyValue(bits[68])
            sector[.radDist] = MapKeyValue(bits[69])
            sector[.road] = MapKeyValue(bits[70])
            sector[.rail] = MapKeyValue(bits[71])
            sector[.defence] = MapKeyValue(bits[72])
            sector[.fallout] = MapKeyValue(bits[73])
            sector[.coast] = MapKeyValue(bits[74])
            sector[.civDeliver] = MapKeyValue(bits[75])
            sector[.milDeliver] = MapKeyValue(bits[76])
            sector[.civCutoff] = MapKeyValue(bits[77])
            sector[.milCutoff] = MapKeyValue(bits[78])
            sector[.terr1] = MapKeyValue(bits[79])
            sector[.terr2] = MapKeyValue(bits[80])
            sector[.terr3] = MapKeyValue(bits[81])
        }
    }
}
