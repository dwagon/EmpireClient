//
//  test_cmd_show_plane.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 13/9/2026.
//
import XCTest

@testable import EmpireClient

@MainActor
final class test_cmd_show_plane: XCTestCase {
    func test_parse_show_plane_str() throws {
        let buildTestString = [
            "Printing for tech level '104'",
            "                          lcm hcm crew avail tech $",
            "f1   Sopwith Camel          8   2    1    32   50 $400",
            "lb   TBD-1 Devastator      10   3    1    36   60 $550",
        ]

        let statsTestString = [
            "Printing for tech level '104'",
            "                          acc load att def ran fuel stlth",
            "f1   Sopwith Camel         76    1   3   3   9    1    0%",
            "lb   TBD-1 Devastator      43    2   0   5  12    1    0%"
        ]

        let capabilityTestString = [
            "Printing for tech level '104'",
            "                          capabilities",
            "f1   Sopwith Camel         tactical intercept VTOL",
            "lb   TBD-1 Devastator      bomber tactical VTOL light"
        ]

        let ans = parse_plane_str(
            buildStr: buildTestString,
            statsStr: statsTestString,
            capStr: capabilityTestString
        )
        XCTAssertEqual(ans["f1"]!.name, "Sopwith Camel")
        XCTAssertEqual(ans["f1"]!.lcmCost, 8)
        XCTAssertEqual(ans["f1"]!.hcmCost, 2)
        XCTAssertEqual(ans["f1"]!.crewCost, 1)
        XCTAssertEqual(ans["f1"]!.avail, 32)
        XCTAssertEqual(ans["f1"]!.tech, 50)
        XCTAssertEqual(ans["f1"]!.cost, 400)
        XCTAssertEqual(ans["f1"]!.acc, 76)
        XCTAssertEqual(ans["f1"]!.load, 1)
        XCTAssertEqual(ans["f1"]!.def, 3)
        XCTAssertEqual(ans["f1"]!.ran, 9)
        XCTAssertEqual(ans["f1"]!.fuel, 1)
        XCTAssertEqual(ans["f1"]!.stealth, 0)
        XCTAssertEqual(ans["f1"]!.capabilities, "tactical intercept VTOL")
        XCTAssertEqual(ans["lb"]!.name, "TBD-1 Devastator")

    }
}
