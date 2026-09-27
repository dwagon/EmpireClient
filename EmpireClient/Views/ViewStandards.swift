//
//  ViewStandards.swift
//  EmpireClient
//
//  Created by Dougal Scott on 27/9/2026.
//

import SwiftUI

private class Standard {
    static let minColWidth: CGFloat = 20
    static let idealColWidth: CGFloat = 30
    static let maxColWidth: CGFloat = 50
}

extension TableColumn {
    func standardWidth() -> Self {
        width(
            min: Standard.minColWidth,
            ideal: Standard.idealColWidth,
            max: Standard.maxColWidth
        )
    }
}
