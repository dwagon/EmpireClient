//
//  test_cmd_sdump.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 14/9/2026.
//

import XCTest

@testable import EmpireClient

@MainActor
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

    func test_parse_sdump() throws {
        let g: Game = Game()
        g.parse_cmd_sdump(testInput)
        XCTAssertEqual(g.ships.count, 4)
        if let ship = g.ships[0] {
            XCTAssertEqual(ship.coords, MapCoord(x: 19, y: 15))
            XCTAssertEqual(ship.eff, 100)

        } else {
            XCTFail("No ship 0 found")
        }
        if let ship = g.ships[1] {
            XCTAssertEqual(ship.fleet, "p")
            XCTAssertEqual(ship.number, 1)
            XCTAssertEqual(ship.name, "ship thing")
        } else {
            XCTFail("No ship 1 found")
        }

        if let ship = g.ships[2] {
            XCTAssertEqual(ship.mob, -28)
            XCTAssertEqual(ship.cargo[.civ]!, 300)
        } else {
            XCTFail("No ship 2 found")
        }

        if let ship = g.ships[3] {
            XCTAssertEqual(ship.abbrev, "oe")
            XCTAssertEqual(ship.cargo[.civ]!, 11)
            XCTAssertEqual(ship.cargo[.mil]!, 12)
            XCTAssertEqual(ship.cargo[.uw]!, 13)
            XCTAssertEqual(ship.cargo[.food]!, 14)
            XCTAssertEqual(ship.planes, 15)
            XCTAssertEqual(ship.heli, 16)
            XCTAssertEqual(ship.xlPlanes, 17)
            XCTAssertEqual(ship.landUnits, 18)
            XCTAssertEqual(ship.mob, 19)
            XCTAssertEqual(ship.tech, 21)
            XCTAssertEqual(ship.cargo[.shells], 22)
            XCTAssertEqual(ship.cargo[.guns], 23)
            XCTAssertEqual(ship.cargo[.petrol], 24)
            XCTAssertEqual(ship.cargo[.ironOre], 25)
            XCTAssertEqual(ship.cargo[.goldDust], 26)
            XCTAssertEqual(ship.cargo[.goldBars], 27)
            XCTAssertEqual(ship.cargo[.oil], 28)
            XCTAssertEqual(ship.cargo[.lcm], 29)
            XCTAssertEqual(ship.cargo[.hcm], 30)
            XCTAssertEqual(ship.cargo[.radioactives], 31)
            XCTAssertEqual(ship.defense, 32)
            XCTAssertEqual(ship.speed, 33)
            XCTAssertEqual(ship.visibility, 34)
            XCTAssertEqual(ship.range, 35)
            XCTAssertEqual(ship.fire, 36)
        } else {
            XCTFail("No ship 3 found")
        }

    }
}
