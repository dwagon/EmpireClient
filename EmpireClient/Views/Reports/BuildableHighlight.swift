//
//  BuildableHighlight.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/9/2026.
//

import SwiftUI

struct BuildableHighlight: ViewModifier {
    var canBuild: Bool

    func body(content: Content) -> some View {
        content.foregroundStyle(
            canBuild ? .primary : .secondary
        )
    }
}
