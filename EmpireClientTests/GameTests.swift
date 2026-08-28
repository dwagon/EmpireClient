//
//  GameTests.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 4/8/2026.
//

import XCTest

@testable import EmpireClient

@MainActor
final class GameTests: XCTestCase {
    func test_parse_show_ship_str() throws {
        let b_str = [
            "Printing for tech level '0'",
            "                          lcm hcm avail tech $",
            "fb   fishing test          25  15    75    0 $180",
            "ss   slave ship            60  40   160    0 $300",
            "frg  frigate               30  30   110    0 $600",
        ]

        let s_str = [
            "Printing for tech level '0'",
            "                               s  v  s  r  f  l  p  h  x",
            "                               p  i  p  n  i  n  l  e  p",
            "                          def  d  s  y  g  r  d  n  l  l",
            "fb   fishing test          11 12 15  2  9  8  7  6  5  4",
            "ss   slave ship            20 10 35  3  0  0  0  0  0  1",
            "frg  frigate               50 25 25  3  1  1  2  0  0  1",
        ]

        let c_str = [
            "Printing for tech level '0'",
            "                           cargoes & capabilities",
            "fb   fishing test          300c 10m 900f 15u fish canal",
            "ss   slave ship            20c 80m 200f 1200u",
            "frg  frigate               60m 10s 2g 60f semi-land",
        ]
        let ans = parse_ship_str(
            buildStr: b_str,
            statsStr: s_str,
            capStr: c_str
        )
        XCTAssertEqual(ans["fb"]!.name, "fishing test")
        XCTAssertEqual(ans["fb"]!.lcmCost, 25)
        XCTAssertEqual(ans["fb"]!.hcmCost, 15)
        XCTAssertEqual(ans["fb"]!.avail, 75)
        XCTAssertEqual(ans["fb"]!.tech, 0)
        XCTAssertEqual(ans["fb"]!.cost, 180)
        XCTAssertEqual(ans["fb"]!.defence, 11)
        XCTAssertEqual(ans["fb"]!.speed, 12)
        XCTAssertEqual(ans["fb"]!.visible, 15)
        XCTAssertEqual(ans["fb"]!.spy, 2)
        XCTAssertEqual(ans["fb"]!.range, 9)
        XCTAssertEqual(ans["fb"]!.fire, 8)
        XCTAssertEqual(ans["fb"]!.landUnits, 7)
        XCTAssertEqual(ans["fb"]!.planes, 6)
        XCTAssertEqual(ans["fb"]!.helicopters, 5)
        XCTAssertEqual(ans["fb"]!.lightPlanes, 4)
        XCTAssertEqual(ans["fb"]!.cargo, "300c 10m 900f 15u fish canal")
        XCTAssertEqual(ans["frg"]!.name, "frigate")
        XCTAssertEqual(ans["ss"]!.name, "slave ship")
    }

    func test_parse_ship_cmd() throws {
        let g = Game()
        let result = [
            "shp#     ship type       x,y   fl   eff civ mil  uw  fd pn he xl ln mob tech",
            "   0 fb   fishing boa    4,0       100%   1   2   3   4  0  0  0  0 127    0",
            " 1 ship",
        ]
        g.parse_ship_cmd(result)

        XCTAssertEqual(g.ships.count, 1)
        XCTAssertTrue(g.ships.keys.contains("0"))
        XCTAssertEqual(g.ships["0"]!.type, "fb")
        XCTAssertEqual(g.ships["0"]!.eff, 100)
        XCTAssertEqual(g.ships["0"]!.mob, 127)
        XCTAssertEqual(g.ships["0"]!.tech, 0)
        XCTAssertEqual(g.ships["0"]!.coords, MapCoord(x:4, y:0))
        XCTAssertEqual(g.ships["0"]!.civ, 1)
        XCTAssertEqual(g.ships["0"]!.mil, 2)
    }
}
