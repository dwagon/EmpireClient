//
//  budget_report.swift
//  EmpireClient
//  https://www.empire.cx/infopages/budget.html
//
//  Created by Dougal Scott on 23/8/2026.
//
//  Sector Type            Production                Cost
//  Sector maintenance          2 sectors                    120
//  Military payroll        110 mil, 0 res                       550
//  Total expenses.......................................................669
//  Income from taxes        7208 civs, 2000 uws                +3809
//  Total income.......................................................+3809
//  Balance forward                                   47301
//  Estimated delta                                   +3140
//  Estimated new treasury.............................................50441

import Foundation

extension Game {
    func cmd_budget() async {
        let result = await client.run_cmd("budget")
        guard result != [] else {
            print("budget returned empty")
            return
        }
        budgetReport = result
    }
}
