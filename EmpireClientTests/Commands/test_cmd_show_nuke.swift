//
//  test_cmd_show_nuke.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 23/9/2026.
//

import XCTest

@testable import EmpireClient

@MainActor
final class test_cmd_show_nuke: XCTestCase {
    func test_parse_show_nuke_str() throws {
        let buildTestString = [
            "Printing for tech level '1000'",
            "              lcm hcm  oil  rad avail tech res $",
            "1mt   fusion   75  75   50  110    77  350   0 $ 40000",
            "60kt  neutron  60  60   30  100    62  355   0 $ 30000",
            "3mt   fusion  100 100   75  130   101  360   0 $ 45000",
            "5mt   fusion  120 120  100  150   122  370   0 $ 50000",
            "120kt neutron  75  75   40  120    77  375   0 $ 36000"
        ]

        let statsTestString = [
            "Printing for tech level '1000'",
            "              blst dam lbs tech res $        abilities",
            "1mt   fusion     6 150   5  350   0 $  40000",
            "60kt  neutron    3  30   2  355   0 $  30000 neutron",
            "3mt   fusion     7 170   6  360   0 $  45000",
            "5mt   fusion     8 190   8  370   0 $  50000",
            "120kt neutron    5  50   3  375   0 $  36000 neutron"
        ]


        let ans = parse_nuke_str(
            buildStr: buildTestString,
            statsStr: statsTestString,
        )
        XCTAssertEqual(ans["60kt neutron"]!.name, "60kt neutron")
        XCTAssertEqual(ans["60kt neutron"]!.lcmCost, 60)
        XCTAssertEqual(ans["60kt neutron"]!.hcmCost, 60)
        XCTAssertEqual(ans["60kt neutron"]!.oilCost, 30)
        XCTAssertEqual(ans["60kt neutron"]!.radCost, 100)
        XCTAssertEqual(ans["60kt neutron"]!.avail, 62)
        XCTAssertEqual(ans["60kt neutron"]!.tech, 355)
        XCTAssertEqual(ans["60kt neutron"]!.research, 0)
        XCTAssertEqual(ans["60kt neutron"]!.cost, 30_000)
        XCTAssertEqual(ans["60kt neutron"]!.blast, 3)
        XCTAssertEqual(ans["60kt neutron"]!.damage, 30)
        XCTAssertEqual(ans["60kt neutron"]!.lbs, 2)
        XCTAssertEqual(ans["60kt neutron"]!.capabilities, "neutron")
        XCTAssertEqual(ans.count, 5)
    }
}
