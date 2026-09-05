//
//  DataLoader.swift
//  EmpireClient
//
//  Created by Dougal Scott on 27/8/2026.
//

import Foundation

struct DataLoader {
    static func loadSampleGame(name: String) -> Game {
    // Iterate over all bundles to find the one containing the resource
    for bundle in Bundle.allBundles {
      if let url = bundle.url(forResource: name, withExtension: "json") {
        do {
          let data = try Data(contentsOf: url)
          let game = try JSONDecoder().decode(Game.self, from: data)
          return game
        } catch {
          fatalError("Failed to decode \(name).json: \(error)")
        }
      }
    }
    fatalError("\(name).json not found in any bundle.")
  }

    static func loadSampleShip(name: String) -> Ship {
    // Iterate over all bundles to find the one containing the resource
    for bundle in Bundle.allBundles {
      if let url = bundle.url(forResource: name, withExtension: "json") {
        do {
          let data = try Data(contentsOf: url)
          let ship = try JSONDecoder().decode(Ship.self, from: data)
          return ship
        } catch {
          fatalError("Failed to decode \(name).json: \(error)")
        }
      }
    }
    fatalError("\(name).json not found in any bundle.")
  }
}
