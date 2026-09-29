//
//  TelegramReport.swift
//  EmpireClient
//
//  Created by Dougal Scott on 26/9/2026.
//

import SwiftUI

struct TelegramReport: View {
    var telegrams: [Telegram]
    @Environment(\.dismiss) private var dismiss
    @State private var selected: Telegram.ID?

    var body: some View {
        NavigationSplitView {
            List(telegrams, selection: $selected) { telegram in
                VStack(alignment: .leading) {
                    Text("\(telegram.from)")
                    Text("\(telegram.date)").font(.caption)
                }
            }
            .navigationSplitViewColumnWidth(250)
        } detail: {
            if let selected {
                if let telegram = telegrams.first(where: { $0.id == selected })
                {
                    TelegramDetails(gram: telegram)
                }
            }
        }
        OkButton() {
            dismiss()
        }
    }
}

struct TelegramDetails: View {
    let gram: Telegram

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(gram.from)").bold()
            Text("\(gram.date)").padding(.trailing).font(.caption)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(gram.content, id: \.self) { line in
                        Text("\(line)")
                    }
                }
            }
        }
    }
}

#Preview {
    let tels = [
        Telegram([
            "> Production Report   dated Sun Sep 27 07:59:00 2026",
            "0 happiness,   0 education produced",
            "0.0000 tech, 0.0000 research produced",
            "money delta was $0 for this update",
        ])!,
        Telegram([
            "> Telegram from POGO, (#0)  dated Sun Sep 27 09:13:57 2026",
            "Testing"
        ])!
    ]

    TelegramReport(telegrams: tels)
}
