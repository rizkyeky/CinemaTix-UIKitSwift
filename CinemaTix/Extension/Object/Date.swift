//
//  ExtDate.swift
//  CinemaTix
//
//  Created by Eky on 23/11/23.
//

import Foundation

extension Date {
    static func from(day: Int, month: Int, year: Int) -> Date? {
        
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        if let date = calendar.date(from: dateComponents) {
            return date
        } else {
            return nil
        }
    }
    
    func getDayOfWeek() -> Int {
        let calendar = Calendar.current
        let components = calendar.component(.day, from: self)
        return components
    }
    
    func getDayName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    func toStringDdMMMMyyyy(format: String = "dd, MMMM yyyy") -> String? {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter
        }()
        return dateFormatter.string(for: self)
    }
}
