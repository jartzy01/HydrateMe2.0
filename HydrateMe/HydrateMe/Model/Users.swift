//
//  Users.swift
//  HydrateMe
//
//  Created by english on 2025-02-12.
//
import FirebaseFirestore
import Foundation

class Users: ObservableObject, Identifiable, Codable {
    @DocumentID var id: String? // Firebase document ID

    @Published var firstName: String
    @Published var lastName: String
    @Published var email: String
    @Published var password: String
    @Published var hydrationGoal: Double
    @Published var hydrationHistory: [HydrationRecord]
//    @Published var rewards: [Rewards]
//    @Published var reminders: [Reminders]

    enum CodingKeys: String, CodingKey {
        case firstName, lastName, email, password, hydrationGoal, hydrationHistory, rewards, reminders
    }
    
    init(firstName: String, lastName: String, email: String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.hydrationGoal = 0
        self.hydrationHistory = []
//        self.rewards = []
//        self.reminders = []
    }
    
    // Decode from Firestore
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        self.hydrationGoal = try container.decode(Double.self, forKey: .hydrationGoal)
        self.hydrationHistory = try container.decodeIfPresent([HydrationRecord].self, forKey: .hydrationHistory) ?? []
        //self.rewards = try container.decodeIfPresent([Rewards].self, forKey: .rewards) ?? []
        //self.reminders = try container.decodeIfPresent([Reminders].self, forKey: .reminders) ?? []
    }

    // Encode to Firestore
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(hydrationGoal, forKey: .hydrationGoal)
        try container.encode(hydrationHistory, forKey: .hydrationHistory)
//        try container.encode(rewards, forKey: .rewards)
//        try container.encode(reminders, forKey: .reminders)
    }

    // MARK: - Validation
    func isValidPassword() -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }

    func isValidEmail() -> Bool {
        let regex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluate(with: email)
    }
    
    
    public func addRewards(){
        
    }
    
    public func addReminder(){
        
    }
    
    public func activateReminder() -> Bool{
        return true
    }
    
    public func doesUserAlrHaveReward(id: Int) -> Bool {
        return false
    }
}
