//
//  cmd_raw.swift
//  EmpireClient
//
//  Created by Dougal Scott on 18/8/2026.
//

import Foundation

extension Game {
    func cmd_raw(_ cmd_string: String) async {
        log(cmd_string)
        let result = await client.run_cmd(cmd_string)
        log(result)
    }
}
