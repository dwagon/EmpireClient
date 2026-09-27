//
//  test_cmd_read.swift
//  EmpireClientTests
//
//  Created by Dougal Scott on 27/9/2026.
//

import XCTest
@testable import EmpireClient

@MainActor
final class test_cmd_read: XCTestCase {
    let testInput = ["",
        "> Telegram from POGO, (#0)  dated Sun Sep 27 09:13:57 2026",
        "Testing",
        "",
        "> Production Report   dated Sun Sep 27 09:51:36 2026",
        "technological breakthroughs (27.56) produced in -1,-1",
        "money delta was $179460 for this update"
    ]

    func test_parse_cmd_read() throws {
        let g = Game()
        g.parse_cmd_read(testInput)
        XCTAssertEqual(g.telegrams.count, 2)
        XCTAssertEqual(g.telegrams[0].date, "Sun Sep 27 09:13:57 2026")
        XCTAssertEqual(g.telegrams[1].date, "Sun Sep 27 09:51:36 2026")

    }
}
