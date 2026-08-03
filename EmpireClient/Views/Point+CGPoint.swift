//
//  Point+CGPoint.swift
//  EmpireClient
//
//  Created by Dougal Scott on 31/7/2026.
//  See https://github.com/fananek/HexGrid-SwiftUI-Demo/blob/main/HexGrid-SwiftUI-Demo/Point%2BCGPoint.swift

import SwiftUI
import HexGrid

extension Point {
    public var cgPoint : CGPoint {
        return CGPoint(x: x, y: y)
    }
}

extension CGPoint {
    public var hexPoint : Point {
        return Point(x: x, y: y)
    }
}
