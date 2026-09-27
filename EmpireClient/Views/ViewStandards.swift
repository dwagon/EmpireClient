//
//  ViewStandards.swift
//  EmpireClient
//
//  Created by Dougal Scott on 27/9/2026.
//

import SwiftUI

private class Standard {
    static let minColWidth: CGFloat = 40
    static let idealColWidth: CGFloat = 50
    static let maxColWidth: CGFloat = 80
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
