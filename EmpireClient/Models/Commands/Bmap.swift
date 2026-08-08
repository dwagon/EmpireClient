//
//  Bmap.swift
//  EmpireClient
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
    func cmd_bmap() async {
        let result = await client.run_cmd("bmap #")
        guard result != [] else {
            print("bmap returned empty")
            return
        }
        print("result=\n\(result)")
        let min_x = get_lower_x(result)

        for line in result[2..<result.count - 2] {  // Skip border
            if line.split(separator: " ").count == 2 {
                continue
            }
            handle_bmap_line(line, min_x: min_x)
        }
    }

    /// Handle a line of the bmap output that contains map data
    private func handle_bmap_line(_ line: String, min_x: Int) {
        let y = Int(line.split(separator: " ", maxSplits: 1)[0])
        if y == nil {
            print("Error in map for line '\(line)'")
            return
        }
        if let left_index = line.firstIndex(of: " "),
            let right_index = line.lastIndex(of: " ")
        {
            let next_index = line.index(after: left_index)
            let map_part = line[next_index...right_index]
            for (pos, char) in map_part.enumerated() {
                let x = pos + min_x
                if is_valid_coord(x: x, y: y!) && char != " " {
                    let coord = MapCoord(x: x, y: y!)
                    set_bmap_sector(coord, to: String(char))
                }
            }
        }
    }

    private func set_bmap_sector(_ coord: MapCoord, to: String) {
        if let sector = game_map[coord] {
            sector.desig = Desig(to)
        } else {
            game_map[coord] = Sector(coords: coord)
            game_map[coord]!.desig = Desig(to)
        }
    }
}

/// Return the x range from the map string
/// --------00000000001
/// 8765432101234567890
func get_lower_x(_ msg: [String]) -> Int {
    var lower_x: Int
    var tens: Int
    var units: Int
    let first_line = msg[0]
    let second_line = msg[1]
    let first_char = first_line[first_line.startIndex]

    if first_line.starts(with: "-") {
        tens = 0
    } else {
        tens = Int(String(first_char))!
    }
    units = Int(String(second_line[second_line.startIndex]))!

    lower_x = tens * 10 + units
    if first_char == "-" {
        lower_x = -lower_x
    }
    return lower_x
}

func is_valid_coord(x: Int, y: Int) -> Bool {
    if (x % 2 == 1) && (y % 2 == 1) {
        return true
    }
    if (x % 2 == 0) && (y % 2) == 0 {
        return true
    }
    return false
}
