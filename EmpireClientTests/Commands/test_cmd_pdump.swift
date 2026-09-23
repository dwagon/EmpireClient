//
//  test_cmd_pdump.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 14/9/2026.
//

import XCTest
@testable import EmpireClient

@MainActor
final class test_cmd_pdump: XCTestCase {
    let testInput: [String] = [
        "Mon Sep 14 11:49:53 2026",
        "DUMP PLANES 1789350593",
        "id type x y wing eff mob tech att def acc react range load fuel hard ship land laun orb nuke grd",
        "0 zep  2 4 ~ 100 60 110 0 -1 52 21 20 2 3 4 -1 -1 N N N/A G",
        "1 plane"
    ]

    func test_parse_pdump() throws {
        let g: Game = Game()
        g.parse_cmd_pdump(testInput)
        XCTAssertEqual(g.planes.count, 1)
        if let plane = g.planes[0] {
            XCTAssertEqual(plane.number, 0)
            XCTAssertEqual(plane.abbrev, "zep")
            XCTAssertEqual(plane.coords, MapCoord(x: 2, y: 4))
            XCTAssertEqual(plane.wing, "~")
            XCTAssertEqual(plane.eff, 100)
            XCTAssertEqual(plane.mob, 60)
            XCTAssertEqual(plane.tech, 110)
            XCTAssertEqual(plane.attack, 0)
            XCTAssertEqual(plane.defence, -1)
            XCTAssertEqual(plane.accuracy, 52)
            XCTAssertEqual(plane.react, 21)
            XCTAssertEqual(plane.range, 20)
            XCTAssertEqual(plane.load, 2)
            XCTAssertEqual(plane.fuel, 3)
            XCTAssertEqual(plane.harden, 4)
            XCTAssertEqual(plane.ship, -1)
            XCTAssertEqual(plane.land, -1)
            XCTAssertEqual(plane.launched, "N")
            XCTAssertEqual(plane.orbit, "N")
            XCTAssertEqual(plane.nuke, "N/A")
            XCTAssertEqual(plane.groundburst, "G")
        }
        else {
            XCTFail("No plane parsed")
        }
    }
}
