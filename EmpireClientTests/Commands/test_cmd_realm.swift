//
//  test_cmd_realm.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 25/9/2026.
//

import XCTest
@testable import EmpireClient

@MainActor
final class test_cmd_realm: XCTestCase {
    let testInput = [
        "Realm #0 is -8:10,-5:5",
        "Realm #1 is 10:24,-2:4",
        "Realm #2 is -22:-11,0:9",
        "Realm #3 is 2:11,-15:-7",
        "Realm #4 is -8:10,-5:5",
    ]

    func test_parse_realm() throws {
        let g = Game()
        g.parse_cmd_realm(testInput)
        XCTAssertEqual(g.realms.count, 4)
        XCTAssertEqual(g.realms[0], Realm(minX: -8, maxX: 10, minY: -5, maxY: 5))
        XCTAssertEqual(g.realms[1], Realm(minX: 10, maxX: 24, minY: -2, maxY: 4))
    }

    func test_realm_quality() throws {
        let r1 = Realm(minX: -8, maxX: 10, minY: -5, maxY: 5)
        let r2 = Realm(minX: -8, maxX: 10, minY: -5, maxY: 5)
        let r3 = Realm(minX: -8, maxX: 10, minY: -5, maxY: 6)

        XCTAssertEqual(r1, r2)
        XCTAssertNotEqual(r1, r3)
    }

    func test_inRealm() throws {
        let r1 = Realm(minX: -8, maxX: 10, minY: -5, maxY: 5)
        let mc1 = MapCoord(x: -5, y: 0)
        let mc2 = MapCoord(x: -10, y: 0)
        XCTAssertTrue(r1.inRealm(coord: mc1))
        XCTAssertFalse(r1.inRealm(coord: mc2))
    }
}
