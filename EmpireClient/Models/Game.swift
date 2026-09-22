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
    var ships: [ShipNum: Ship] = [:]

    var landTypes: [String: LandType] = [:]
    var landUnits: [LandNum: LandUnit] = [:]

    var planeTypes: [String: PlaneType] = [:]
    var planes: [PlaneNum: Plane] = [:]

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

    func landUnitsAt(_ coord: MapCoord?) -> [LandUnit] {
        if let coord {
            return  Array(landUnits.values).filter {
                $0.coords == coord
            }
        }
        return []
    }

    func landUnitsAboard(_ ship: Ship) -> [LandUnit] {
        return Array(landUnits.values).filter {
            $0.ship == Int(ship.number)
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

    func get_initial_data() async {
        await cmd_nation()
        await cmd_prod()
        shipTypes = await cmd_show_ship()
        landTypes = await cmd_show_land()
        planeTypes = await cmd_show_plane()
    }

    func get_data() async {
        await cmd_dump()
        await cmd_map()
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
        ships = try values.decode([ShipNum: Ship].self, forKey: .ships)
        shipTypes = try values.decode(
            [String: ShipType].self,
            forKey: .shipTypes
        )
    }
}
