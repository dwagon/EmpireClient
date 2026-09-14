//
//  test_cmd_sdump.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 14/9/2026.
//

import XCTest

@testable import EmpireClient

final class test_cmd_sdump: XCTestCase {
    let testInput: [String] = [
        "'Mon Sep 14 11:30:15 2026'",
        "DUMP SHIPS 1789347597",
        "id type x y flt eff civ mil uw food pln he xl land mob fuel tech shell gun petrol iron dust bar oil lcm hcm rad def spd vis rng fir origx origy name",
        "0 frg  19 15 ~ 100 0 1 0 60 0 0 0 0 95 0 0 0 0 0 0 0 0 0 0 0 0 50 25 25 1 1 1 -3 \"Boaty\"",
        "1 fb   5 -3 p 100 300 0 0 413 0 0 0 0 -27 0 0 0 0 0 0 0 0 0 0 0 0 10 10 15 0 0 -1 5 \"ship thing\"",
        "2 fb   -12 -6 ~ 100 300 10 0 900 0 0 0 0 -28 0 0 0 0 0 0 0 0 0 0 0 0 10 10 15 0 0 1 -3 \"\"",
        "3 oe   0 6 ~ 100 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 -1 5 \"\"",
        "4 ships",
    ]

    func test_parse_ship() throws {
        let g: Game = Game()
        g.parse_cmd_sdump(testInput)
        XCTAssertEqual(g.ships.count, 4)
        XCTAssertEqual(g.ships["0"]?.coords, MapCoord(x:19, y:15))
        XCTAssertEqual(g.ships["1"]?.fleet, "p")
        XCTAssertEqual(g.ships["1"]?.number, "1")
        XCTAssertEqual(g.ships["1"]?.name, "ship thing")
        XCTAssertEqual(g.ships["3"]?.abbrev, "oe")
        XCTAssertEqual(g.ships["0"]?.eff, 100)
        XCTAssertEqual(g.ships["2"]?.mob, -28)
        XCTAssertEqual(g.ships["2"]?.cargo[.civ]!, 300)
        XCTAssertEqual(g.ships["3"]?.cargo[.civ]!, 11)
        XCTAssertEqual(g.ships["3"]?.cargo[.mil]!, 12)
        XCTAssertEqual(g.ships["3"]?.cargo[.uw]!, 13)
        XCTAssertEqual(g.ships["3"]?.cargo[.food]!, 14)
        XCTAssertEqual(g.ships["3"]?.planes, 15)
        XCTAssertEqual(g.ships["3"]?.heli, 16)
        XCTAssertEqual(g.ships["3"]?.xlPlanes, 17)
        XCTAssertEqual(g.ships["3"]?.landUnits, 18)
        XCTAssertEqual(g.ships["3"]?.mob, 19)
        XCTAssertEqual(g.ships["3"]?.tech, 21)
        XCTAssertEqual(g.ships["3"]?.cargo[.shells], 22)
        XCTAssertEqual(g.ships["3"]?.cargo[.guns], 23)
        XCTAssertEqual(g.ships["3"]?.cargo[.petrol], 24)
        XCTAssertEqual(g.ships["3"]?.cargo[.ironOre], 25)
        XCTAssertEqual(g.ships["3"]?.cargo[.goldDust], 26)
        XCTAssertEqual(g.ships["3"]?.cargo[.goldBars], 27)
        XCTAssertEqual(g.ships["3"]?.cargo[.oil], 28)
        XCTAssertEqual(g.ships["3"]?.cargo[.lcm], 29)
        XCTAssertEqual(g.ships["3"]?.cargo[.hcm], 30)
        XCTAssertEqual(g.ships["3"]?.cargo[.radioactives], 31)
        XCTAssertEqual(g.ships["3"]?.defence, 32)
        XCTAssertEqual(g.ships["3"]?.speed, 33)
        XCTAssertEqual(g.ships["3"]?.visibility, 34)
        XCTAssertEqual(g.ships["3"]?.range, 35)
        XCTAssertEqual(g.ships["3"]?.fire, 36)
    }
}
