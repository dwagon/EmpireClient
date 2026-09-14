//
//  test_cmd_pdump.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 14/9/2026.
//

import XCTest
@testable import EmpireClient

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
        XCTAssertEqual(g.planes["0"]?.number, "0")
        XCTAssertEqual(g.planes["0"]?.abbrev, "zep")
        XCTAssertEqual(g.planes["0"]?.coords, MapCoord(x: 2, y: 4))
        XCTAssertEqual(g.planes["0"]?.wing, "~")
        XCTAssertEqual(g.planes["0"]?.eff, 100)
        XCTAssertEqual(g.planes["0"]?.mob, 60)
        XCTAssertEqual(g.planes["0"]?.tech, 110)
        XCTAssertEqual(g.planes["0"]?.attack, 0)
        XCTAssertEqual(g.planes["0"]?.defence, -1)
        XCTAssertEqual(g.planes["0"]?.accuracy, 52)
        XCTAssertEqual(g.planes["0"]?.react, 21)
        XCTAssertEqual(g.planes["0"]?.range, 20)
        XCTAssertEqual(g.planes["0"]?.load, 2)
        XCTAssertEqual(g.planes["0"]?.fuel, 3)
        XCTAssertEqual(g.planes["0"]?.harden, 4)
        XCTAssertEqual(g.planes["0"]?.ship, "-1")
        XCTAssertEqual(g.planes["0"]?.land, "-1")
        XCTAssertEqual(g.planes["0"]?.launched, "N")
        XCTAssertEqual(g.planes["0"]?.orbit, "N")
        XCTAssertEqual(g.planes["0"]?.nuke, "N/A")
        XCTAssertEqual(g.planes["0"]?.groundburst, "G")
    }
}
