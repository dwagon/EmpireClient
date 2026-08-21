//
//  UserProfile.swift
//  EmpireClient
//
//  Created by Dougal Scott on 21/8/2026.
//

import Foundation

struct UserProfile: Codable {
    var country: String
    var password: String
    var thresholds: [DefaultThreshold]
}

struct DefaultThreshold: Identifiable, Codable {
    let id: UUID

    let desig: DesigType
    let item: [Item: Int?]

    init(
        id: UUID = UUID(),
        desig: DesigType,
        item: [Item: Int?]
    ) {
        self.id = id
        self.desig = desig
        self.item = item
    }
}

func loadSettings() -> UserProfile {
    if let data = UserDefaults.standard.data(forKey: "userProfile"),
        let decoded = try? JSONDecoder().decode(UserProfile.self, from: data)
    {
        return decoded
    }

    return default_user_profile
}

func saveSettings(profile: UserProfile) {
    if let encoded = try? JSONEncoder().encode(profile) {
        UserDefaults.standard.set(encoded, forKey: "userProfile")
    }
}

var default_user_profile = UserProfile(
    country: "",
    password: "",
    thresholds: default_thresholds
)

private var default_thresholds: [DefaultThreshold] = [
    DefaultThreshold(
        desig: .unknown,
        item: [.civ: 500, .uw: 100, .food: 100]
    ),
    DefaultThreshold(
        desig: .mine,
        item: [.civ: 500, .uw: 100, .food: 100, .ironOre: 0]
    ),
    DefaultThreshold(
        desig: .light_manufacturing,
        item: [.civ: 500, .uw: 100, .food: 100, .ironOre: 500]
    ),
    DefaultThreshold(
        desig: .heavy_manufacturing,
        item: [.civ: 500, .uw: 100, .food: 100, .ironOre: 500]
    ),
    DefaultThreshold(
        desig: .refinery,
        item: [.civ: 500, .uw: 100, .food: 100, .oil: 500]
    ),
    DefaultThreshold(
        desig: .bank,
        item: [.civ: 500, .uw: 100, .food: 100, .goldDust: 500]
    ),
    DefaultThreshold(
        desig: .library,
        item: [.civ: 500, .uw: 100, .food: 100, .lcm: 500, .hcm: 500]
    ),
]
