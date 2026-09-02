//
//  Bmap.swift
//  EmpireClient
//  See https://www.empire.cx/infopages/bmap.html
//
//  Created by Dougal Scott on 7/8/2026.
//
//      --------00000000001
//      8765432101234567890
//   -5                     -5
//   -4                     -4
//   -3      . . - - -      -3
//   -2     . - - - - .     -2
//   -1    . . - - - . .    -1
//    0   - - - c c - . .   0
//    1    - - - - - . .    1
//    2     - - - - . .     2
//    3      - - - . .      3
//    4                     4
//    5                     5
//      --------00000000001
//      8765432101234567890

import Foundation

extension Game {
    func cmd_map(cmdArg: String = "*") async {
        for cmd in ["bmap", "map"] {
            await process_map_cmd(cmd: cmd, cmdArg: cmdArg)
        }
    }

    func process_map_cmd(cmd: String, cmdArg: String) async {
        let result = await client.runCmd("\(cmd) \(cmdArg)")
        var minX: Int
        guard result != [] else {
            print("map returned empty")
            return
        }

        do {
            minX = try get_lower_x(result)
        } catch ParseError.invalidMapData (let line) {
            print("cmd_map(\(cmd)) Failed to parse \(line)")
            return
        } catch {
            print("cmd_map(\(cmd) Failed to fail \(error)")
            return
        }

        for line in result[2..<result.count - 2] {  // Skip border
            if line.split(separator: " ").count == 2 {
                continue
            }
            handle_map_line(line, minX: minX)
        }
    }

    /// Handle a line of the bmap output that contains map data
    private func handle_map_line(_ line: String, minX: Int) {
        let y = Int(line.split(separator: " ", maxSplits: 1)[0])
        if y == nil {
            log("Error in map for line '\(line)'")
            return
        }
        if let leftIndex = line.firstIndex(of: " "),
            let rightIndex = line.lastIndex(of: " ")
        {
            let nextIndex = line.index(after: leftIndex)
            let mapPart = line[nextIndex...rightIndex]
            for (pos, char) in mapPart.enumerated() {
                let x = pos + minX
                if is_valid_coord(x: x, y: y!) && char != " " {
                    let coord = MapCoord(x: x, y: y!)
                    set_map_sector(coord, to: String(char))
                }
            }
        }
    }

    private func set_map_sector(_ coord: MapCoord, to: String) {
        if let sector = gameMap[coord] {
            sector.desig = Desig(to)
        } else {
            gameMap[coord] = Sector(coords: coord)
            gameMap[coord]!.desig = Desig(to)
        }
    }
}

/// Return the x range from the map string
/// --------00000000001
/// 8765432101234567890
func get_lower_x(_ msg: [String]) throws -> Int {
    var lowerX: Int
    var tens: Int
    var units: Int
    let firstLine = msg[0]
    let secondLine = msg[1]
    let firstChar = firstLine[firstLine.startIndex]

    if firstLine.starts(with: "-") {
        tens = 0
    } else {
        let maybe_tens = Int(String(firstChar))
        if maybe_tens == nil {
            throw ParseError.invalidMapData(firstLine)
        }
        else {
            tens = maybe_tens!
        }
    }
    units = Int(String(secondLine[secondLine.startIndex]))!

    lowerX = tens * 10 + units
    if firstLine.contains("-") {
        lowerX = -lowerX
    }
    return lowerX
}

func is_valid_coord(x: Int, y: Int) -> Bool {
    if abs(x) % 2 == abs(y) % 2 {
        return true
    }
    return false
}
