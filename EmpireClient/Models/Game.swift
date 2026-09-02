//
//  Game.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation

// MARK: -
@Observable
class Game: Decodable {
    var gameMap: Map
    var client = TCPClient()
    var nationReport: [String] = []
    var budgetReport: [String] = []
    var logs: [String] = []
    var shipTypes: [String: ShipType] = [:]
    var ships: [String: Ship] = [:]

    init() {
        gameMap = Map(xSize: MapConfig.mapWidth, ySize: MapConfig.mapHeight)
    }

    var shipTable: [Ship] {
        return Array(ships.values).sorted {
            $0.number < $1.number
        }
    }

    subscript(key: MapCoord) -> Sector?
    {
        get {
            return gameMap[key]
        }
        set {
            gameMap[key] = newValue
        }
    }

    func log(_ line: String) {
        if line.contains("\n") {
            for subline in line.split(separator: "\n") {
                logs.append(String(subline))
            }
        }
        else {
            logs.append(line)
        }
    }

    func log(_ lines: [String]) {
        for line in lines {
            log(line)
        }
    }

    // MARK: -
    func login(country: String, password: String) async {
        var result = await client.run_cmd("coun \(country)")
        log(result)
        result = await client.run_cmd("pass \(password)")
        if result.contains("\"pass\" is not a legal command") {
            result = await client.run_cmd("break")
        }
        log(result)
        result = await client.run_cmd("play")
        log(result)
    }

    func get_data() async {
        await cmd_dump()
        await cmd_map()
        await cmd_nation()
        await cmd_budget()
        await cmd_prod()
        await cmd_show_ship()
        await cmd_ship()
    }

    enum CodingKeys: String, CodingKey {
//        case game_map
        case nationReport
        case budgetReport
        case ships
        case shipTypes
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameMap = Map()
        client = TCPClient()
        nationReport = try values.decode([String].self, forKey: .nationReport)
        budgetReport = try values.decode([String].self, forKey: .budgetReport)
        logs = []
        ships = try values.decode([String: Ship].self, forKey: .ships)
        shipTypes = try values.decode([String: ShipType].self, forKey: .shipTypes)
    }
}
