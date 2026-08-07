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

final class DoubleWidthTests: XCTestCase {
    let pointy = Orientation.pointyOnTop
    let even = OffsetLayout.even

    func test_doubleWidthToCube_origin() throws {
        let offset = OffsetCoordinates(column: 0, row: 0, orientation: pointy, offsetLayout: even)
        let cube = try doubleWidthToCube(from: offset)
        XCTAssertEqual(try CubeCoordinates(x: 0, y: 0, z: 0), cube)
    }

    func test_doubleWidthToCube() throws {
        var offset: OffsetCoordinates
        var cube: CubeCoordinates

        offset = OffsetCoordinates(column: 4, row: 2, orientation: pointy, offsetLayout: even)
        cube = try doubleWidthToCube(from: offset)
        XCTAssertEqual(try CubeCoordinates(x: 1, y: 2, z: -3), cube)

        offset = OffsetCoordinates(column: -2, row: 2, orientation: pointy, offsetLayout: even)
        cube = try doubleWidthToCube(from: offset)
        XCTAssertEqual(try CubeCoordinates(x: -2, y: 2, z: 0), cube)
    }

    func test_cubeToDoubleWidth_origin() throws {
        var offset: OffsetCoordinates
        var cube: CubeCoordinates

        cube = try CubeCoordinates(x: 0, y:0, z:0)
        offset = OffsetCoordinates(column: 0, row: 0, orientation: pointy, offsetLayout: even)
        XCTAssertEqual(cubeToDoubleWidth(from: cube, orientation: pointy, offsetLayout: even), offset)
    }

    func test_cubeToDoubleWidth() throws {
        var offset: OffsetCoordinates
        var cube: CubeCoordinates

        cube = try CubeCoordinates(x: 3, y:-2, z:-1)
        offset = OffsetCoordinates(column: 4, row: -2, orientation: pointy, offsetLayout: even)
        XCTAssertEqual(cubeToDoubleWidth(from: cube, orientation: pointy, offsetLayout: even), offset)

        cube = try CubeCoordinates(x: -1, y:-1, z:2)
        offset = OffsetCoordinates(column: -3, row: -1, orientation: pointy, offsetLayout: even)
        XCTAssertEqual(cubeToDoubleWidth(from: cube, orientation: pointy, offsetLayout: even), offset)
    }
}

