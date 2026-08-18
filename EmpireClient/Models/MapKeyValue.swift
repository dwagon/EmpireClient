//
//  MapKeyValue.swift
//  EmpireClient
//
//  Created by Dougal Scott on 5/8/2026.
//

import Foundation

enum MapKeyException: Error {
    case invalidType
}

/// Value for a Map Key - can be either int or string
enum MapKeyValue: CustomStringConvertible, Equatable {
    init(_ rawValue: Substring) {
        if let isInt = Int(String(rawValue)) {
            self = .int(Int(isInt))
        }
        else {
            self = .str(String(rawValue))
        }
    }

    var description: String {
        switch self {
        case .str(let string):
            return string
        case .int(let int):
            return "\(String(int))"
        }
    }

    func toInt() throws -> Int {
        switch(self) {
        case let .int(num):
            return num
        case let .str(string):
            print("MapKeyValue not an int - \(string)")
            throw MapKeyException.invalidType
        }
    }

    case str(String)
    case int(Int)
}
