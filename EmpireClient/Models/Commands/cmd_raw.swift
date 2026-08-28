//
//  cmd_raw.swift
//  EmpireClient
//
//  Created by Dougal Scott on 18/8/2026.
//

import Foundation

extension Game {
    func cmd_raw(_ cmdString: String) async {
        log(cmdString)
        let result = await client.run_cmd(cmdString)
        log(result)
    }
}
