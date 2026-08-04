//
//  MapTests.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 4/8/2026.
//

import XCTest
@testable import EmpireClient

final class MapTests: XCTestCase {

    func test_validCoord() throws {
        let m = Map(x_size: 5, y_size: 5)
        let good_coord = MapCoord(x: 0, y: 0)
        let bad_coord = MapCoord(x: -9, y:9)
        XCTAssertTrue(m.validCoord(good_coord))
        XCTAssertFalse(m.validCoord(bad_coord))
    }

}
