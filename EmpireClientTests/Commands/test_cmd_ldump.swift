//
//  test_cmd_ldump.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 14/9/2026.
//

import XCTest

@testable import EmpireClient

final class test_cmd_ldump: XCTestCase {

    let testInput: [String] = [
        "Mon Sep 14 17:29:40 2026",
        "DUMP LAND UNITS 1789370980",
        "id type x y army eff mil fort mob food fuel tech retr react xl nland land ship shell gun petrol iron dust bar oil lcm hcm rad att def vul spd vis spy radius frg acc dam amm aaf uw civ",
        "0 cav  -1 1 ~ 10 1 2 3 4 5 119 42 6 7 8 -1 -1 9 10 11 12 13 14 15 16 17 18 1.65 0.69 71 38 18 4 3 19 20 21 22 23 24 25",
        "1 unit",
    ]

    func test_parse_ldump() throws {
        let g: Game = Game()
        g.parse_cmd_ldump(testInput)
        XCTAssertEqual(g.landUnits.count, 1)
        XCTAssertEqual(g.landUnits["0"]?.number, "0")
        XCTAssertEqual(g.landUnits["0"]?.abbrev, "cav")
        XCTAssertEqual(g.landUnits["0"]?.coords, MapCoord(x: -1, y: 1))
        XCTAssertEqual(g.landUnits["0"]?.army, "~")
        XCTAssertEqual(g.landUnits["0"]?.eff, 10)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.mil], 1)
        XCTAssertEqual(g.landUnits["0"]?.fort, 2)
        XCTAssertEqual(g.landUnits["0"]?.mob, 3)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.food]!, 4)
        XCTAssertEqual(g.landUnits["0"]?.tech, 119)
        XCTAssertEqual(g.landUnits["0"]?.retr, 42)
        XCTAssertEqual(g.landUnits["0"]?.react, 6)
        XCTAssertEqual(g.landUnits["0"]?.xl, 7)
        XCTAssertEqual(g.landUnits["0"]?.nland, 8)
        XCTAssertEqual(g.landUnits["0"]?.land, "-1")
        XCTAssertEqual(g.landUnits["0"]?.ship, "-1")
        XCTAssertEqual(g.landUnits["0"]?.cargo[.shells], 9)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.guns], 10)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.petrol], 11)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.ironOre], 12)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.goldDust], 13)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.goldBars], 14)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.oil], 15)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.lcm], 16)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.hcm], 17)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.radioactives], 18)
        XCTAssertEqual(g.landUnits["0"]?.att, 1.65)
        XCTAssertEqual(g.landUnits["0"]?.def, 0.69)
        XCTAssertEqual(g.landUnits["0"]?.vul, 71)
        XCTAssertEqual(g.landUnits["0"]?.spd, 38)
        XCTAssertEqual(g.landUnits["0"]?.vis, 18)
        XCTAssertEqual(g.landUnits["0"]?.spy, 4)
        XCTAssertEqual(g.landUnits["0"]?.radius, 3)
        XCTAssertEqual(g.landUnits["0"]?.frg, 19)
        XCTAssertEqual(g.landUnits["0"]?.acc, 20)
        XCTAssertEqual(g.landUnits["0"]?.dam, 21)
        XCTAssertEqual(g.landUnits["0"]?.amm, 22)
        XCTAssertEqual(g.landUnits["0"]?.aaf, 23)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.uw], 24)
        XCTAssertEqual(g.landUnits["0"]?.cargo[.civ], 25)
    }
}
