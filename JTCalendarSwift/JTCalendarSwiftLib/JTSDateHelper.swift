//
//  JTSDateHelper.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/7.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit

class JTSDateHelper: NSObject {
    
    private var pCalendar:Calendar!
    
    var calendar:Calendar {
        get {
            if pCalendar == nil {
                pCalendar = Calendar.init(identifier: .gregorian)
                pCalendar.timeZone = TimeZone.current
                pCalendar.locale = Locale.current
            }
            return pCalendar
        }
    }
    
    func createDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = self.calendar.timeZone
        dateFormatter.locale = self.calendar.locale
        return dateFormatter
    }
    
    // MARK: - 日期操作
    func addToDate(_ date:Date,months:Int) -> Date {
        var components = DateComponents()
        components.month = months
        return self.calendar.date(byAdding: components, to: date)!
    }
    
    func addToDate(_ date:Date,weeks:Int) -> Date {
        var components = DateComponents()
        components.day = 7 * weeks
        return self.calendar.date(byAdding: components, to: date)!
    }
    
    func addToDate(_ date:Date,days:Int) -> Date {
        var components = DateComponents()
        components.day = days
        return self.calendar.date(byAdding: components, to: date)!
    }
    
    // MARK:- 帮助
    func numberOfWeeks(_ date:Date) -> UInt {
        let firstDay = self.firstDayOfMonth(date)
        let lastDay = self.lastDayOfMonth(date)
        let componentsA = self.calendar.dateComponents([.weekOfYear], from: firstDay)
        let componentsB = self.calendar.dateComponents([.weekOfYear], from: lastDay)
        return UInt((componentsB.weekOfYear! - componentsA.weekOfYear!.advanced(by: 52 + 1)) % 52)
    }
    
    // MARK:- firstDayOfMonth
    func firstDayOfMonth(_ date:Date) -> Date {
        let componentsCurrentDate = self.calendar.dateComponents([.year,.month,.day,.weekday,.weekOfMonth], from: date)
        var componentsNewDate = DateComponents()
        componentsNewDate.year = componentsCurrentDate.year
        componentsNewDate.month = componentsCurrentDate.month
        componentsNewDate.weekOfMonth = 1
        componentsNewDate.day = 1
        return self.calendar.date(from: componentsNewDate)!
    }
    
    // MARK:- lastDayOfMonth
    func lastDayOfMonth(_ date:Date) -> Date {
        let componentsCurrentDate = self.calendar.dateComponents([.year,.month,.day,.weekday,.weekOfMonth], from: date)
        var componentsNewDate = DateComponents()
        componentsNewDate.year = componentsCurrentDate.month! + 1
        componentsNewDate.day = 0
        return self.calendar.date(from: componentsNewDate)!
    }
    
    // MARK:- firstWeekDayOfMonth
    func firstWeekDayOfMonth(_ date:Date) -> Date {
        let firstDayOfMonth = self.firstDayOfMonth(date)
        return self.firstWeekDayOfMonth(firstDayOfMonth)
    }
    
    // MARK:- firstWeekDayOfWeek
    func firstWeekDayOfWeek(_ date:Date) -> Date {
        let componentsCurrentDate = self.calendar.dateComponents([.year,.month,.day,.weekday,.weekOfMonth], from: date)
        var componentsNewDate = DateComponents()
        componentsNewDate.year = componentsCurrentDate.year
        componentsNewDate.month = componentsCurrentDate.month
        componentsNewDate.weekOfMonth = componentsCurrentDate.weekOfMonth
        componentsNewDate.weekday = self.calendar.firstWeekday
        return self.calendar.date(from: componentsNewDate)!
    }
    
    // MARK:- 比较
    func isTheSameMonthThan(_ dateA:Date,_ dateB:Date) -> Bool {
        let componentsA = self.calendar.dateComponents([.year,.month], from: dateA)
        let componentsB = self.calendar.dateComponents([.year,.month], from: dateB)
        return componentsA.year == componentsB.year && componentsA.month == componentsB.month
    }
    
    func isTheSameWeekThan(_ dateA:Date,_ dateB:Date) -> Bool {
        let componentsA = self.calendar.dateComponents([.year,.weekOfYear], from: dateA)
        let componentsB = self.calendar.dateComponents([.year,.weekOfYear], from: dateB)
        return componentsA.year == componentsB.year && componentsA.weekOfYear == componentsB.weekOfYear
    }
    
    func isTheSameDayThan(_ dateA:Date,_ dateB:Date) -> Bool {
        let componentsA = self.calendar.dateComponents([.year,.month,.day], from: dateA)
        let componentsB = self.calendar.dateComponents([.year,.month,.day], from: dateB)
        return componentsA.year == componentsA.year && componentsA.month == componentsB.month && componentsA.day == componentsB.day
    }
    
    func isEqualOrBefore(_ dateA:Date,_ dateB:Date) -> Bool {
        if dateA.compare(dateB) == .orderedAscending  || self.isTheSameDayThan(dateA, dateB) {
            return true
        }
        return false
    }
    
    func isEqualOrAfter(_ dateA:Date,_ dateB:Date) -> Bool {
        if dateA.compare(dateB) == .orderedDescending || self.isTheSameDayThan(dateA, dateB){
            return true
        }
        return false
    }
    
    func isBetweenAtStartDateAndEndDate(_ date:Date,startDate:Date,endDate:Date) -> Bool {
        if self.isEqualOrAfter(date, startDate) && self.isEqualOrBefore(date, endDate){
            return true
        }
        return false
    }
}
