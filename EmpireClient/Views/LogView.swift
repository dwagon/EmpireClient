//
//  LogView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 16/8/2026.
//

import SwiftUI

struct LogView: View {
    var logs: [String]

    var body: some View {
        let log_str = logs.joined(separator: "\n")
        ScrollView(.vertical) {
            Text(log_str)
                .font(.system(.body, design: .monospaced))
        }
        .defaultScrollAnchor(.bottom)
        .layoutPriority(0)
        .frame(minWidth: 800, maxWidth: 1000,  maxHeight: 120, alignment: .leading)
        .border(.cyan)
        .padding()
    }
}

#Preview {
    let logs = [
        "This is a long list of", "       the cat sat on the mat",
        "The Quick Brown Fox was a lazy bastard",
    ]
    LogView(logs: logs)
}
