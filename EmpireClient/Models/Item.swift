//
//  Item.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
