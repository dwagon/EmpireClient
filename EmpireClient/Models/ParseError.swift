//
//  ParseError.swift
//  EmpireClient
//
//  Created by Dougal Scott on 2/9/2026.
//

import Foundation

enum ParseError: Error {
    case invalidCoordinate(String)
    case invalidMapData(String)
}
