//
//  MapKeyValueTests.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 5/8/2026.
//

import XCTest
@testable import EmpireClient


final class MapKeyValueTests: XCTestCase {
    func testInitInt() throws {
        let m = MapKeyValue("1")
        switch m {
        case let .int(int_val):
            XCTAssertEqual(int_val, 1)
        default:
            XCTFail("Int not converted")
        }
    }

    func testInitString() throws {
        let m = MapKeyValue("Hello")
        switch m {
        case let .str(str_val):
            XCTAssertEqual(str_val, "Hello")
        default:
            XCTFail("String not converted")
        }
    }
}

