//
//  Users.swift
//  HydrateMe
//
//  Created by english on 2025-02-12.
//

import Foundation

class Users{
    var userId: String
    public var firstName: String
    public var lastName: String
    public var email: String
    public var password: String
    public var hydrationGoal: Double
    public var hydrationHistory: [HydrationRecord]
    public var rewards: [Rewards]
    public var reminders: [Reminders]
    
    public init(firstName: String, lastName: String, email: String ,password: String) {
        self.userId = ""
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.hydrationGoal = 0
        self.hydrationHistory = []
        self.rewards = []
        self.reminders = []
    }
    
    public func getUserId() -> String {
        return userId
    }
    
    public func setUserId(_ userId: String) {
        self.userId = userId
    }
    
    public func getFirstName() -> String {
        return firstName
    }

    public func setFirstName(_ firstName: String)  {
        self.firstName = firstName
    }
    
    public func getLastName() -> String {
        return lastName
    }

    public func setLastName(_ lastName: String)  {
        self.lastName = lastName
    }
    
    public func getEmail() -> String {
        return email
    }
    

    public func setEmail(_ email: String) {
        self.email = email
    }
    
    public func getPassword() -> String {
        return password
    }

    public func setPassword(_ password: String) {
        self.password = password
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", regex)
        return predicate.evaluate(with: email)
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
