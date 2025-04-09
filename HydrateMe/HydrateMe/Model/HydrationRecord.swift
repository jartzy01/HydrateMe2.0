//
//  HydrationRecord.swift
//  HydrateMe
//
//  Created by english on 2025-03-12.
//

import Foundation

class HydrationRecord: Identifiable, Codable {
    public var recordId: String = UUID().uuidString
    private var date: Date
    public var amountIntake: Double
    
    public init(recordId: String = UUID().uuidString, date: Date, amountIntake: Double) {
        self.recordId = recordId
        self.date = date
        self.amountIntake = amountIntake
    }
    
    public func getRecordId() -> String {
        return recordId
    }
    
    public func getDate() -> Date {
        return date
    }
    
    public func getAmountIntake() -> Double {
        return amountIntake
    }
    
    public func setRecordId(_ recordId: String = UUID().uuidString) {
        self.recordId = recordId
    }
    
    public func setDate(_ date: Date) {
        self.date = date
    }
    
    public func setAmountIntake(_ amountIntake: Double) {
        self.amountIntake = amountIntake
    }
}
