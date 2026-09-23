//
//  BuildableHighlight.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/9/2026.
//

import SwiftUI

extension View {
    func buildableHighlight(_ canBuild: Bool) -> some View {
        modifier(BuildableHighlight(canBuild: canBuild))
    }
}

struct BuildableHighlight: ViewModifier {
    var canBuild: Bool

    func body(content: Content) -> some View {
        content.foregroundStyle(
            canBuild ? .primary : .secondary
        )
    }
}
