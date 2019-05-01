//
//  Date+.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/22/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation

enum DateRoundingType {
    case round
    case ceil
    case floor
}

enum DateError: Error {
    case invalidDate(String)
}

struct DateModel: Equatable, Comparable, Hashable {
    static func == (lhs: DateModel, rhs: DateModel) -> Bool {
        return lhs.date == rhs.date
    }
    
    static func < (lhs: DateModel, rhs: DateModel) -> Bool {
        return lhs.date < rhs.date
    }
    
    private(set) var date: Date
    private(set) var day: Int
    private(set) var month: Int
    private(set) var monthStr: String
    private(set) var year: Int
    private(set) var weekday: Int
    private(set) var weekdayStr: String
    
    init?(_ date: Date) {
        self.date = date
        
        let calendar       = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: date)
        
        guard
            let day            = dateComponents.day,
            let month          = dateComponents.month,
            let year           = dateComponents.year,
            let weekday        = dateComponents.weekday,
            let monthStr       = DateFormatter().monthSymbols[optional: month - 1],
            let weekdayStr     = DateFormatter().weekdaySymbols[optional: weekday - 1] else
        {
            return nil
        }
        
        
        self.day        = day
        self.month      = month
        self.monthStr   = monthStr
        self.year       = year
        self.weekday    = weekday
        self.weekdayStr = weekdayStr
    }
    
    mutating func set(_ date: Date) throws {
        self.date = date
        
        let calendar       = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: date)
        
        guard
            let day            = dateComponents.day,
            let month          = dateComponents.month,
            let year           = dateComponents.year,
            let weekday        = dateComponents.weekday,
            let monthStr       = DateFormatter().monthSymbols[optional: month - 1],
            let weekdayStr     = DateFormatter().weekdaySymbols[optional: weekday - 1] else
        {
            throw DateError.invalidDate("Unable to get properties from date.")
        }
        
        self.day        = day
        self.month      = month
        self.monthStr   = monthStr
        self.year       = year
        self.weekday    = weekday
        self.weekdayStr = weekdayStr
    }
}

extension Date {
    func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }
    func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        var roundedInterval: TimeInterval = 0
        switch rounding  {
        case .round:
            roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceil:
            roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:
            roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Date(timeIntervalSinceReferenceDate: roundedInterval)
    }
    
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }
    
    // 2019-03-26T00:00:00Z
    static func from(formattedDate: String, timezone: TimeZone) -> Date? {
        if formattedDate.count != 20 {
            return nil
        }
        
        let yearBeginIndex = formattedDate.startIndex
        let yearEndIndex = formattedDate.index(yearBeginIndex, offsetBy: 4)
        let year = formattedDate[yearBeginIndex..<yearEndIndex]
        
        let monthBeginIndex = formattedDate.index(yearEndIndex, offsetBy: 1)
        let monthEndIndex = formattedDate.index(monthBeginIndex, offsetBy: 2)
        let month = formattedDate[monthBeginIndex..<monthEndIndex]
        
        let dayBeginIndex = formattedDate.index(monthEndIndex, offsetBy: 1)
        let dayEndIndex = formattedDate.index(dayBeginIndex, offsetBy: 2)
        let day = formattedDate[dayBeginIndex..<dayEndIndex]
        
        let hourBeginIndex = formattedDate.index(dayEndIndex, offsetBy: 1)
        let hourEndIndex = formattedDate.index(hourBeginIndex, offsetBy: 2)
        let hour = formattedDate[hourBeginIndex..<hourEndIndex]
        
        let minuteBeginIndex = formattedDate.index(hourEndIndex, offsetBy: 1)
        let minuteEndIndex = formattedDate.index(minuteBeginIndex, offsetBy: 2)
        let minute = formattedDate[minuteBeginIndex..<minuteEndIndex]
        
        let secondBeginIndex = formattedDate.index(minuteEndIndex, offsetBy: 1)
        let secondEndIndex = formattedDate.index(secondBeginIndex, offsetBy: 2)
        let second = formattedDate[secondBeginIndex..<secondEndIndex]
        
        var dateComponents    = DateComponents()
        dateComponents.year   = Int(year)
        dateComponents.month  = Int(month)
        dateComponents.day    = Int(day)
        dateComponents.hour   = Int(hour)
        dateComponents.minute = Int(minute)
        dateComponents.second = Int(second)
        
        var calendar = Calendar.current
        calendar.timeZone = timezone
        
        return calendar.date(from: dateComponents)
    }
    
    var formatted: String? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        
        guard
            let year = components.year,
            let month = components.month,
            let day = components.day,
            let hour = components.hour,
            let minute = components.minute,
            let second = components.second
        else {
            return nil
        }
        
        // Add leading zeroes
        let yearStr = String(format: "%04d", year)
        let monthStr = String(format: "%02d", month)
        let dayStr = String(format: "%02d", day)
        let hourStr = String(format: "%02d", hour)
        let minuteStr = String(format: "%02d", minute)
        let secondStr = String(format: "%02d", second)
        
        return "\(yearStr)-\(monthStr)-\(dayStr)T\(hourStr):\(minuteStr):\(secondStr)Z"
    }
    
    func isInSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    func isInSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    func isInSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    func isInSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
    var isInThisWeek: Bool {
        return isInSameWeek(date: Date().convertToTimeZone(initTimeZone: TimeZone(abbreviation: "UTC")!, timeZone: TimeZone.current))
    }
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    var isInTheFuture: Bool {
        return Date().convertToTimeZone(initTimeZone: TimeZone(abbreviation: "UTC")!, timeZone: TimeZone.current) < self
    }
    var isInThePast: Bool {
        return self < Date().convertToTimeZone(initTimeZone: TimeZone(abbreviation: "UTC")!, timeZone: TimeZone.current)
    }
}
