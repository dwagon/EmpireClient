//
//  OptimizeSector.swift
//  EmpireClient
//
//  Created by Dougal Scott on 8/9/2026.
//

import Foundation

extension Game {
    /// Optimize all sectors
    func optimize() {
        for sector in gameMap.allSectors() {
            optimize(coord: sector.coords)
        }
    }

    /// Optimize sector of a type
    func optimize(desig: Desig) {
        for sector in gameMap.instances(desig.desig) {
            optimize(coord: sector.coords)
        }
    }

    /// Optimize a single sector
    func optimize(coord: MapCoord) {
        if let sector = gameMap[coord] {
            do {
                if let str1 = try sector[.max1]?.toString() {
                    optimizeResource(resourceStr: str1, coord: coord)
                }
                if let str2 = try sector[.max2]?.toString() {
                    optimizeResource(resourceStr: str2, coord: coord)
                }
                if let str3 = try sector[.max3]?.toString() {
                    optimizeResource(resourceStr: str3, coord: coord)
                }
            } catch {
                print("Unhandled error \(error)")
            }
        }
    }

    /// Take resource like "130d" and apply it to a sector
    func optimizeResource(resourceStr: String, coord: MapCoord) {
        let regex = /(\d+)(.)/
        do {
            if let matches = try regex.firstMatch(in: resourceStr) {
                let amount = Int(matches.1)!
                let resource = String(matches.2)
                Task {
                    await cmd_threshold(
                        item: resource,
                        coord: coord,
                        level: amount
                    )
                }
            }
        } catch {
            print("optimizeResource(\(resourceStr)) didn't match: \(error)")
        }
    }
}
