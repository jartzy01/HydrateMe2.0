//
//  HydrationRecord.swift
//  HydrateMe
//
//  Created by english on 2025-03-12.
//

import Foundation

class HydrationRecord: ObservableObject, Codable, Identifiable {
    var id: String { recordId }

    @Published var recordId: String
    @Published var date: Date
    @Published var amountIntake: Double

    // MARK: - Initializer
    init(recordId: String, date: Date, amountIntake: Double) {
        self.recordId = recordId
        self.date = date
        self.amountIntake = amountIntake
    }

    // MARK: - Codable Support
    enum CodingKeys: String, CodingKey {
        case recordId, date, amountIntake
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recordId = try container.decode(String.self, forKey: .recordId)
        date = try container.decode(Date.self, forKey: .date)
        amountIntake = try container.decode(Double.self, forKey: .amountIntake)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recordId, forKey: .recordId)
        try container.encode(date, forKey: .date)
        try container.encode(amountIntake, forKey: .amountIntake)
    }
}
