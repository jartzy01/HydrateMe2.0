//
//  MainViewModel.swift
//  HydrateMe
//
//  Created by english on 2025-04-10.
//
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var record: HydrationRecord
    
    init(record: HydrationRecord) {
        self.record = record
        FirebaseModel.shared.currentRecord = record
    }
    
    func increaseIntake() {
        record.amountIntake += 10
        FirebaseModel.shared.currentRecord = record
    }
    
    func decreaseIntake() {
        record.amountIntake = max(0, record.amountIntake - 10)
        FirebaseModel.shared.currentRecord = record
    }
    
    func saveHydration(completion: @escaping (Result<Void, Error>) -> Void) {
        FirebaseModel.shared.saveHydration(completion: completion)
    }
}

