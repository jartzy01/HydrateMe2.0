//
//  HydrationRecord.swift
//  HydrateMe
//
//  Created by english on 2025-03-12.
//

import Foundation

class HydrationRecord{
    static var lastUsedId = 0
    var id: Int
    var amount: Int
    var date: Date
    
    init(amount: Int, date: Date) {
        self.id = HydrationRecord.lastUsedId
        self.amount = amount
        self.date = date
        HydrationRecord.lastUsedId += 100
    }
    
    public func getId() -> Int {
        return id
    }
    
    public func setId(id: Int) {
        self.id = id
    }
    
    public func getAmount() -> Int {
        return amount
    }
    
    public func setAmount(amount: Int) {
        self.amount = amount
    }
    
    public func getDate() -> Date {
        return date
    }
    
    public func setDate(date: Date) {
        self.date = date
    }
    
    func dayOfWeek() -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self.date) - 1
    }
    
    func weekOfMonth() -> Int {
        let calendar = Calendar.current
        let weekOfMonth = calendar.component(.weekOfMonth, from: self.date)
        return weekOfMonth
    }
    
    func monthOfYear() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self.date)
    }
    
    public func setWeeklyStat(records: [HydrationRecord]) -> [String: Int] {
        var weeklyStats: [String: Int] = ["Monday": 0, "Tuesday": 0, "Wednesday": 0, "Thursday": 0, "Friday": 0, "Saturday": 0, "Sunday": 0]
        
        for record in records {
            let dayIndex = record.dayOfWeek()
            switch dayIndex {
            case 0:
                weeklyStats["Monday"]! += record.amount
            case 1:
                weeklyStats["Tuesday"]! += record.amount
            case 2:
                weeklyStats["Wednesday"]! += record.amount
            case 3:
                weeklyStats["Thursday"]! += record.amount
            case 4:
                weeklyStats["Friday"]! += record.amount
            case 5:
                weeklyStats["Saturday"]! += record.amount
            case 6:
                weeklyStats["Sunday"]! += record.amount
            default:
                break
            }
        }
        
        return weeklyStats
    }
    
    public func setMontlyStat(records: [HydrationRecord]) -> [String: Int] {
        var montlyStats: [String: Int] = ["Week 1": 0, "Week 2": 0, "Week 3": 0, "Week 4": 0]
        
        for record in records {
            let weekIndex = record.weekOfMonth()
            switch weekIndex {
            case 1:
                montlyStats["Week 1"]! += record.amount
            case 2:
                montlyStats["Week 2"]! += record.amount
            case 3:
                montlyStats["Week 3"]! += record.amount
            case 4:
                montlyStats["Week 4"]! += record.amount
            default:
                break
            }
        }
        return montlyStats
    }
    
    public func setYearlyStat(records: [HydrationRecord]) -> [String: Int] {
        var yearlyStats: [String: Int] = [
            "January": 0, "February": 0, "March": 0, "April": 0, "May": 0, "June": 0, "July": 0, "August": 0, "September": 0, "October": 0, "November": 0, "December": 0
        ]
        
        for record in records {
            let monthIndex = record.monthOfYear()
            switch monthIndex {
            case 1:
                yearlyStats["January"]! += record.amount
            case 2:
                yearlyStats["February"]! += record.amount
            case 3:
                yearlyStats["March"]! += record.amount
            case 4:
                yearlyStats["April"]! += record.amount
            case 5:
                yearlyStats["May"]! += record.amount
            case 6:
                yearlyStats["June"]! += record.amount
            case 7:
                yearlyStats["July"]! += record.amount
            case 8:
                yearlyStats["September"]! += record.amount
            case 9:
                yearlyStats["October"]! += record.amount
            case 10:
                yearlyStats["November"]! += record.amount
            case 11:
                yearlyStats["December"]! += record.amount
            default:
                break
            }
        }
        return yearlyStats
    }
}
