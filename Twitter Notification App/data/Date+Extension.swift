//
//  Date+Extension.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/6/23.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    func getTimeDifferenceString() -> String {
        let currentTime = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: self, to: currentTime)
        
        if let days = components.day, days != 0 {
            return " \(days > 0 ? "+" : "-") \(days) day\(days == 1 ? "" : "s")"
        } else if let hours = components.hour, hours != 0 {
            return "\(hours > 0 ? "+" : "-") \(hours) hour\(hours == 1 ? "" : "s")"
        } else if let minutes = components.minute, minutes != 0 {
            return "\(minutes > 0 ? "+" : "-") \(minutes) minute\(minutes == 1 ? "" : "s")"
        } else if let seconds = components.second, seconds != 0 {
            return "\(seconds > 0 ? "+" : "-") \(seconds) second\(seconds == 1 ? "" : "s")"
        } else {
            return "Just now"
        }
    }
    
    func toString(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
