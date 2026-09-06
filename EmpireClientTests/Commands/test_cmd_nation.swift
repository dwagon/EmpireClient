//
//  test_cmd_nation.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 6/9/2026.
//

import XCTest

@testable import EmpireClient

@MainActor
final class test_cmd_nation: XCTestCase {
    func test_extract_budget() throws {
        let input = [
            "(#1) 1 Nation Report    Sun Sep  6 10:13:20 2026",
            "Nation status is ACTIVE     Bureaucratic Time Units: 597",
            "100% eff capital at 0,0 has 700 civilians & 50 military",
            "The treasury has $392748.00     Military reserves: 1231",
            "Education.......... 26.40       Happiness....... 15.81",
            "Technology.........  0.00       Research........  0.00",
            "Technology factor : 25.00%     Plague factor :   0.00%",
            "Max population : 1000",
            "Max safe population for civs/uws: 769/869",
            "Happiness needed is 7.80"
        ]
        let g = Game()
        let num = g.extract_treasury(from: input)
        XCTAssertEqual(num, 392748)

    }
}

