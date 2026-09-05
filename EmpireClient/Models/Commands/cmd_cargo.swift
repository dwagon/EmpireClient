//
//  cmd_cargo.swift
//  EmpireClient
//
//  Created by Dougal Scott on 4/9/2026.
//  See https://www.empire.cx/infopages/cargo.html

import Foundation

extension Game {
    func cmd_cargo() async {
        let cmdString = "cargo *"
        let result = await client.runCmd(cmdString)
        guard result != [] else {
            print("cargo returned empty")
            return
        }
        log(result)
        parse_cmd_cargo(result)
    }

    // shp#         x,y   flt eff  civ mil  uw  sh gun pet irn dst bar oil lcm hcm rad
    //    0 fb      9,-3     100% 210   1   0   0   0   0   0   0   0   0   0   0   0
    //    1 fb      4,0      100%  50   1   0   0   0   0   0   0   0   0   0   0   0
    //    2 fb     -4,4      100%  20  10   0   0   0   0   0   0   0   0   0   0   0
    // 3 ships
    func parse_cmd_cargo(_ input: [String]) {
        for line in input[1...input.count - 2] {
            let shipNum = String(line.split(separator: " ")[0])
            let newCargo = parse_cmd_cargo_line(line)
            ships[shipNum]!.cargo.merge(newCargo) { (_, new) in new }
        }
    }

    func parse_cmd_cargo_line(_ input: String) -> [Item:Int] {
        let bits = input.split(separator: " ")
        var newCargo: [Item:Int] = [:]
        newCargo[Item.civ] = Int(bits[4])!
        newCargo[Item.mil] = Int(bits[5])!
        newCargo[Item.uw] = Int(bits[6])!
        newCargo[Item.shells] = Int(bits[7])!
        newCargo[Item.guns] = Int(bits[8])!
        newCargo[Item.petrol] = Int(bits[9])!
        newCargo[Item.ironOre] = Int(bits[10])!
        newCargo[Item.goldDust] = Int(bits[11])!
        newCargo[Item.goldBars] = Int(bits[12])!
        newCargo[Item.oil] = Int(bits[13])!
        newCargo[Item.lcm] = Int(bits[14])!
        newCargo[Item.hcm] = Int(bits[15])!
        newCargo[Item.radioactives] = Int(bits[16])!
        return newCargo
    }
}
