//
//  LogView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 16/8/2026.
//

import SwiftUI

struct LogView: View {
    var logs: [Log]

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                ForEach(logs) { log in
                    switch log.type {
                    case .cmd:
                        Text(log.entry)
                            .font(.system(.body, design: .monospaced, weight: .bold))
                    case .result:
                        Text(log.entry)
                            .font(.system(.body, design: .monospaced))
                    case .undefined:
                        Text(log.entry)
                            .font(.system(.body, design: .monospaced, weight: .light))
                    case .silent:
                        EmptyView()
                    }
                }
            }
        }
        .defaultScrollAnchor(.bottom)
        .layoutPriority(0)
        .frame(minWidth: 800, maxWidth: 1000, maxHeight: 120, alignment: .leading)
        .border(.cyan)
        .padding()
    }
}

#Preview {
    let logs = [
        Log(type: .cmd, entry:"This is a long list of"),
        Log(type: .result, entry:"       the cat sat on the mat"),
        Log(type: .undefined, entry:"The Quick Brown Fox was a lazy dog"),
        Log(type: .silent, entry: "The cat is a bastard")
    ]
    LogView(logs: logs)
}
