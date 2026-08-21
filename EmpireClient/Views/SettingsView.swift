//
//  SettingsView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 19/8/2026.
//

import SwiftUI

struct SettingsView: View {
    @State var userProfile = loadSettings()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            TabView {
                Tab("General", systemImage: "gear") {
                    GeneralSettings(profile: $userProfile)
                }
                Tab("Thresholds", systemImage: "lessthanorequalto") {
                    ThresholdSettings(profile: $userProfile)
                }
            }
            .scenePadding()
        }
        Spacer()
        HStack {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
            Button("OK", role: .confirm) {
                saveSettings(profile: userProfile)
                dismiss()

            }
        }
    }
}

struct ThresholdSettings: View {
    @Binding var profile: UserProfile

    @State var populationThresholdCollapse: Bool = true
    @State var resourceThresholdCollapse: Bool = false
    @State var militaryThresholdCollapse: Bool = false

    var body: some View {
        Section(isExpanded: $populationThresholdCollapse) {
            PopulationThresholdSettings
        } header: {
            HStack {
                Text("Population Thresholds")
                Spacer()
                ExpandButton(isExpanded: $populationThresholdCollapse)
            }
        }
        Section(isExpanded: $resourceThresholdCollapse) {
            ResourceThresholdSettings
        } header: {
            HStack {
                Text("Resource Thresholds")
                Spacer()
                ExpandButton(isExpanded: $resourceThresholdCollapse)
            }
        }
        Section(isExpanded: $militaryThresholdCollapse) {
            MilitaryThresholdSettings
        } header: {
            HStack {
                Text("Military Thresholds")
                Spacer()
                ExpandButton(isExpanded: $militaryThresholdCollapse)
            }
        }
    }

    var PopulationThresholdSettings: some View {
        Table(profile.thresholds) {
            TableColumn("Sector") { threshold in
                Text("\(Desig(threshold.desig).name)")
            }
            TableColumn("Civ") { threshold in
                CellView(threshold: threshold, itemType: .civ)
            }
            TableColumn("Mil") { threshold in
                CellView(threshold: threshold, itemType: .mil)
            }
            TableColumn("UW") { threshold in
                CellView(threshold: threshold, itemType: .uw)
            }
        }.tableStyle(.bordered)
    }

    var ResourceThresholdSettings: some View {
        Table(profile.thresholds) {
            TableColumn("Sector") { threshold in
                Text("\(Desig(threshold.desig).name)")
            }
            TableColumn("Food") { threshold in
                CellView(threshold: threshold, itemType: .food)
            }
            TableColumn("Iron Ore") { threshold in
                CellView(threshold: threshold, itemType: .ironOre)
            }
            TableColumn("Gold Dust") { threshold in
                CellView(threshold: threshold, itemType: .goldDust)
            }
            TableColumn("Gold Bars") { threshold in
                CellView(threshold: threshold, itemType: .goldBars)
            }
            TableColumn("Oil") { threshold in
                CellView(threshold: threshold, itemType: .oil)
            }
            TableColumn("LCM") { threshold in
                CellView(threshold: threshold, itemType: .lcm)
            }
            TableColumn("HCM") { threshold in
                CellView(threshold: threshold, itemType: .hcm)
            }
            TableColumn("Radioactives") { threshold in
                CellView(threshold: threshold, itemType: .radioactives)
            }
        }.tableStyle(.bordered)
    }

    var MilitaryThresholdSettings: some View {
        Table(profile.thresholds) {
            TableColumn("Sector") { threshold in
                Text("\(Desig(threshold.desig).name)")
            }
            TableColumn("Shells") { threshold in
                CellView(threshold: threshold, itemType: .shells)
            }
            TableColumn("Guns") { threshold in
                CellView(threshold: threshold, itemType: .guns)
            }
            TableColumn("Planes") { threshold in
                CellView(threshold: threshold, itemType: .planes)
            }
        }.tableStyle(.bordered)
    }

}

struct GeneralSettings: View {
    @Binding var profile: UserProfile
    @State var country: String = ""
    @State var password: String = ""

    var body: some View {
        Text("General Settings")
        HStack {
            Text("Country:")
            TextField("Country", text: $country)
                .disableAutocorrection(true)
        }
        HStack {
            Text("Password:")
            TextField("Password", text: $password)
                .disableAutocorrection(true)
        }
        .onAppear {
            country = profile.country
            password = profile.password
        }
    }
}

struct CellView: View {
    var threshold: DefaultThreshold
    var itemType: Item

    var body: some View {
        if let val = threshold.item[itemType] {
            return Text("\(val!)")
        }
        return Text("?")
    }
}

#Preview {
    SettingsView()
}

#Preview("General") {
    @Previewable @State var userProfile = loadSettings()

    GeneralSettings(profile: $userProfile)
}

#Preview("Threshold") {
    @Previewable @State var userProfile = loadSettings()

    ThresholdSettings(profile: $userProfile)
}
