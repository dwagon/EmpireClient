//
//  test_cmd_show_land.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 11/9/2026.
//

import XCTest

@testable import EmpireClient

@MainActor
final class test_cmd_show_land: XCTestCase {
    func test_parse_show_land_str() throws {
        let buildTestString = [
            "Printing for tech level '44'",
            "                          lcm hcm guns avail tech $",
            "cav  cavalry               10   5    0    40   30 $500",
            "art  artillery             20  10    0    60   35 $800",
            "linf light infantry         8   4    0    36   40 $300",
            "tra  train                100  50    0   220   40 $3500",
            "spy  infiltrator           10   5    0    40   40 $750",
        ]

        let statsTestString = [
            "Printing for tech level '44'",
            "                                       s  v  s  r  r  a  f  a  a  x  l",
            "                                       p  i  p  a  n  c  i  m  a  p  n",
            "                          att def vul  d  s  y  d  g  c  r  m  f  l  d",
            "cav  cavalry              1.4 0.6  76 34 18  4  3  0  0  0  0  0  0  0",
            "art  artillery            0.1 0.4  67 19 20  1  0  8 48  5  2  1  0  0",
            "linf light infantry       1.1 1.6  58 29 15  2  1  0  0  0  1  1  0  0",
            "tra  train                0.0 0.0 117 10 25  3  0  0  0  0  0  0  5 12",
            "spy  infiltrator          0.0 0.0  78 33 18  4  3  0  0  0  0  0  0  0",
        ]

        let capabilityTestString = [
            "Printing for tech level '44'",
            "                          capabilities",
            "cav  cavalry               20m 12f light recon",
            "art  artillery             25m 40s 10g 24f light",
            "linf light infantry        25m 1s 15f light assault",
            "tra  train                 990m 990s 200g 990p 500i 500d 100b 990f 990o 990l 990h 150r supply train heavy",
            "spy  infiltrator           light recon assault spy",
        ]
        let ans = parse_land_str(
            buildStr: buildTestString,
            statsStr: statsTestString,
            capStr: capabilityTestString
        )
        XCTAssertEqual(ans["art"]!.name, "artillery")
        XCTAssertEqual(ans["art"]!.lcmCost, 20)
        XCTAssertEqual(ans["art"]!.hcmCost, 10)
        XCTAssertEqual(ans["art"]!.avail, 60)
        XCTAssertEqual(ans["art"]!.tech, 35)
        XCTAssertEqual(ans["art"]!.cost, 800)
        XCTAssertEqual(ans["art"]!.att, 0.1)
        XCTAssertEqual(ans["art"]!.def, 0.4)
        XCTAssertEqual(ans["art"]!.vulnerability, 67)
        XCTAssertEqual(ans["art"]!.speed, 19)
        XCTAssertEqual(ans["art"]!.visible, 20)
        XCTAssertEqual(ans["art"]!.spy, 1)
        XCTAssertEqual(ans["art"]!.reactionRadius, 0)
        XCTAssertEqual(ans["art"]!.range, 8)
        XCTAssertEqual(ans["art"]!.accuracy, 48)
        XCTAssertEqual(ans["art"]!.fire, 5)
        XCTAssertEqual(ans["art"]!.ammo, 2)
        XCTAssertEqual(ans["art"]!.aaf, 1)
        XCTAssertEqual(ans["art"]!.xpl, 0)
        XCTAssertEqual(ans["art"]!.lnd, 0)
        XCTAssertEqual(ans["art"]!.capabilities, "25m 40s 10g 24f light")
        XCTAssertEqual(ans["linf"]!.name, "light infantry")



    }

    //    func test_parse_ship_cmd() throws {
    //        let g = Game()
    //        let result = [
    //            "shp#     ship type       x,y   fl   eff civ mil  uw  fd pn he xl ln mob tech",
    //            "   0 fb   fishing boa    4,0       100%   1   2   3   4  0  0  0  0 127    0",
    //            " 1 ship",
    //        ]
    //        g.parse_ship_cmd(result)
    //
    //        XCTAssertEqual(g.ships.count, 1)
    //        XCTAssertTrue(g.ships.keys.contains("0"))
    //        XCTAssertEqual(g.ships["0"]!.type, "fb")
    //        XCTAssertEqual(g.ships["0"]!.eff, 100)
    //        XCTAssertEqual(g.ships["0"]!.mob, 127)
    //        XCTAssertEqual(g.ships["0"]!.tech, 0)
    //        XCTAssertEqual(g.ships["0"]!.coords, MapCoord(x: 4, y: 0))
    //        XCTAssertEqual(g.ships["0"]!.cargo[.civ], 1)
    //        XCTAssertEqual(g.ships["0"]!.cargo[.mil], 2)
    //    }
}
