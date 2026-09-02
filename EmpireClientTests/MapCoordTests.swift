//
//  MapCoordTests.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 6/8/2026.
//

import HexGrid
import XCTest

@testable import EmpireClient

@MainActor
final class MapCoordTests: XCTestCase {
    func testInitOffset() throws {
        let mc = MapCoord(
            OffsetCoordinates(
                column: 2,
                row: 3,
                orientation: .pointyOnTop,
                offsetLayout: .odd
            )
        )
        XCTAssertEqual(mc, MapCoord(x: 4, y: 3))
    }

    func testInitCube() throws {
        let mc = MapCoord(try CubeCoordinates(x: 2, y: -1, z: -1))
        XCTAssertEqual(mc, MapCoord(x: 3, y: -1))
    }
}

@MainActor
final class DoubleWidthTests: XCTestCase {
    let pointy = Orientation.pointyOnTop
    let even = OffsetLayout.even

    func test_doubleWidthToCube_origin() throws {
        let offset = MapCoord(x: 0, y: 0)
        let cube = try doubleWidthToCube(from: offset)
        XCTAssertEqual(try CubeCoordinates(x: 0, y: 0, z: 0), cube)
    }

    func test_doubleWidthToCube() throws {
        var cube: CubeCoordinates

        cube = try doubleWidthToCube(from: MapCoord(x: 4, y: 2))
        XCTAssertEqual(try CubeCoordinates(x: 1, y: 2, z: -3), cube)

        cube = try doubleWidthToCube(from: MapCoord(x: -2, y: 2))
        XCTAssertEqual(try CubeCoordinates(x: -2, y: 2, z: 0), cube)
    }

    func test_cubeToDoubleWidth_origin() throws {
        let cube = try CubeCoordinates(x: 0, y: 0, z: 0)
        XCTAssertEqual(
            cubeToDoubleWidth(
                from: cube
            ),
            MapCoord(x: 0, y: 0)
        )
    }

    func test_plusEqual() throws {
        var a = MapCoord(x: 10, y: 10)
        let b = MapCoord(x: 1, y: 1)
        let c = MapCoord(x: -2, y: 2)
        a += b
        XCTAssertEqual(a, MapCoord(x: 11, y: 11))
        a += c
        XCTAssertEqual(a, MapCoord(x: 9, y: 13))
    }

    func test_cubeToDoubleWidth() throws {
        // Note that the coordinates are rotated to make work better, so these are slightly different to what you expect
        var cube: CubeCoordinates

        cube = try CubeCoordinates(x: 3, y: -2, z: -1)
        XCTAssertEqual(
            cubeToDoubleWidth(
                from: cube
            ),
            MapCoord(x: 5, y: -1)
        )

        cube = try CubeCoordinates(x: -1, y: -1, z: 2)
        XCTAssertEqual(
            cubeToDoubleWidth(
                from: cube
            ),
            MapCoord(x: 0, y: 2)
        )
    }
}
