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
    var powerReport: [String] = []
    var logs: [Log] = []

    var shipTypes: [String: ShipType] = [:]
    var ships: [String: Ship] = [:]

    var landTypes: [String: LandType] = [:]
    var landUnits: [String: LandUnit] = [:]

    var planeTypes: [String: PlaneType] = [:]
    var planes: [String: Plane] = [:]

    var treasury: Int = 0
    var techLevel: Float = 0

    init() {
        gameMap = Map(xSize: MapConfig.mapWidth, ySize: MapConfig.mapHeight)
    }

    var shipTable: [Ship] {
        return Array(ships.values).sorted {
            $0.number < $1.number
        }
    }

    var planeTable: [Plane] {
        return Array(planes.values).sorted {
            $0.number < $1.number
        }
    }

    var landTable: [LandUnit] {
        return Array(landUnits.values).sorted {
            $0.number < $1.number
        }
    }

    /// Return if a ship can be built with the current tech
    func isShipBuildable(_ shipType: String) -> Bool {
        if let shipType = shipTypes[shipType] {
            return shipType.tech <= Int(techLevel)
        }
        return false
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

    func runCmd(_ cmdString: String, suppressLog: Bool = false) async
        -> [String]
    {
        var result: [String]
        if suppressLog {
            result = await client.runCmd(cmdString)
        } else {
            log(cmdString, logType: .cmd)
            result = await client.runCmd(cmdString)
            log(result, logType: .result)
        }
        return result
    }

    // MARK: -
    func login(country: String, password: String) async {
        let _ = await runCmd("coun \(country)")
        let _ = await runCmd("pass \(password)", suppressLog: true)
        let _ = await runCmd("play")
    }

    func get_data() async {
        await cmd_dump()
        await cmd_map()
        await cmd_nation()
        await cmd_prod()
        shipTypes = await cmd_show_ship()
        landTypes = await cmd_show_land()
        planeTypes = await cmd_show_plane()
    }

    enum CodingKeys: String, CodingKey {
        // case game_map
        // case client
        case nationReport
        case budgetReport
        // case powerReport
        // case logs
        case shipTypes
        case ships
        // case treasury
        // case techLevel
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameMap = Map()
        client = TCPClient()
        nationReport = try values.decode([String].self, forKey: .nationReport)
        budgetReport = try values.decode([String].self, forKey: .budgetReport)
        logs = []
        ships = try values.decode([String: Ship].self, forKey: .ships)
        shipTypes = try values.decode(
            [String: ShipType].self,
            forKey: .shipTypes
        )
    }
}
