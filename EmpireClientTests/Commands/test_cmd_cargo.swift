//
//  test_cmd_cargo.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 4/9/2026.
//

import XCTest

@testable import EmpireClient

@MainActor
final class test_cmd_cargo: XCTestCase {
    func test_parse_cmd_cargo() throws {
        let input = [
            "shp#         x,y   flt eff  civ mil  uw  sh gun pet irn dst bar oil lcm hcm rad",
            " 0 ts      9,-3     100% 210   1   2   9   8   6   3   12   100   101   23   45   67",
            "1 fb      4,0      100%  50   3  4   5   6   12   13  99   98   55   32   11   42",
            "2 ships",
        ]
        let g = Game()
        g.ships = ["0": Ship(), "1": Ship()]
        g.parse_cmd_cargo(input)
        XCTAssertEqual(g.ships["0"]!.cargo[.civ], 210)
        XCTAssertEqual(g.ships["1"]!.cargo[.civ], 50)

    }

    func test_parse_cmd_cargo_line() throws {
        let input_str =
            "1 fb      4,0      100%  50   3  4   0   6   12   13  99   98   55   32   11   42"
        let g = Game()
        let ans = g.parse_cmd_cargo_line(input_str)
        XCTAssertEqual(ans[.civ], 50)
        XCTAssertEqual(ans[.mil], 3)
        XCTAssertEqual(ans[.uw], 4)
        XCTAssertEqual(ans[.shells], 0)
        XCTAssertEqual(ans[.guns], 6)
        XCTAssertEqual(ans[.petrol], 12)
        XCTAssertEqual(ans[.ironOre], 13)
        XCTAssertEqual(ans[.goldDust], 99)
        XCTAssertEqual(ans[.goldBars], 98)
        XCTAssertEqual(ans[.oil], 55)
        XCTAssertEqual(ans[.lcm], 32)
        XCTAssertEqual(ans[.hcm], 11)
        XCTAssertEqual(ans[.radioactives], 42)

    }
}
