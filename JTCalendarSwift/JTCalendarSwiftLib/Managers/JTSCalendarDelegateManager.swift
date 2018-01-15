//
//  JTSCalendarDelegateManager.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/7.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit
open class JTSCalendarDelegateManager:NSObject {
    
    weak var manager: JTSCalendarManager?
    
    
    // MARK:- Menu View
    func buildMenuItemView() -> UIView {
        if let view = manager?.delegate?.calendarBuildMenuItemView?(self.manager!) {
            return view
        }
        let label = UILabel()
        label.textAlignment = .center
        return label
    }
    
    //- (void)prepareMenuItemView:(UIView *)menuItemView date:(NSDate *)date
    func prepareMenuItemView(_ menuItemView:UIView,_ date:Date?){
        if manager?.delegate?.calendar?(self.manager!, prepareMenuItemView: menuItemView, date: date!) == nil {
            var text: String? = nil
            if (date != nil) {
                let calendar: Calendar? = manager?.dateHelper?.calendar
                let comps: DateComponents? = calendar?.dateComponents([.year, .month], from: date!)
                var currentMonthIndex: Int = (comps?.month!)!
                var dateFormatter: DateFormatter? = nil
                if dateFormatter == nil {
                    dateFormatter = manager?.dateHelper?.createDateFormatter()
                }
                dateFormatter?.timeZone = manager?.dateHelper?.calendar.timeZone
                dateFormatter?.locale = manager?.dateHelper?.calendar.locale!
                while currentMonthIndex <= 0 {
                    currentMonthIndex += 12
                }
                text = dateFormatter?.standaloneMonthSymbols[currentMonthIndex - 1].capitalized
            }
            (menuItemView as? UILabel)?.text = text
        }
    }
    
    // MARK:- Content View
    func buildPageView() -> JTSCalendarPageView {
        //return manager?.delegate?.calendarBuildPageView?(self.manager!) ?? JTSCalendarPageView()
        if let pageView = manager?.delegate?.calendarBuildPageView?(self.manager!) {
            return pageView
        }
        return JTSCalendarPageView()
    }
    
    func canDisplayPageWithDate(_ date:Date) -> Bool {
        if let canDisplay = manager?.delegate?.calendar?(self.manager!, canDisplayPageWith: date) {
            return canDisplay
        }
        return true
    }
    
    //- (NSDate *)dateForPreviousPageWithCurrentDate:(NSDate *)currentDate
    func dateForPreviousPageWithCurrentDate(_ currentDate:Date?) -> Date{
        assert(currentDate != nil , "currentDate cannot be nil")
        if let prevDate = manager?.delegate?.calendar?(self.manager!, dateForPreviousPageWithCurrentDate: currentDate!) {
            return prevDate
        }
        return (manager?.settings?.isWeekModeEnabled == true ? manager?.dateHelper?.addToDate(currentDate!, weeks: -1) : manager?.dateHelper?.addToDate(currentDate!, months: -1))!
    }
    //- (NSDate *)dateForNextPageWithCurrentDate:(NSDate *)currentDate
    func dateForNextPageWithCurrentDate(_ currentDate:Date?) -> Date{
        assert(currentDate != nil , "currentDate cannot be nil")
        if let nextDate = manager?.delegate?.calendar?(self.manager!, dateForNextPageWithCurrentDate:currentDate!) {
            return nextDate
        }
        return (manager?.settings?.isWeekModeEnabled == true ? manager?.dateHelper?.addToDate(currentDate!, weeks: 1) : manager?.dateHelper?.addToDate(currentDate!, months: 1))!
    }
    
    // MARK:- page View
    func buildWeekDayView() -> JTSCalendarWeekDayView {
        if let weekDayView = manager?.delegate?.calendarBuildWeekDayView?(self.manager!) {
            return weekDayView
        }
        return JTSCalendarWeekDayView()
    }
    
    func buildWeekView() -> JTSCalendarWeekView {
        if let weekView = manager?.delegate?.calendarBuildWeekView?(self.manager!) {
            return weekView
        }
        return JTSCalendarWeekView()
    }
    
    // MARK:- Week View
    func buildDayView() -> JTSCalendarDayView {
        if let dayView = manager?.delegate?.calendarBuildDayView?(self.manager!) {
            return dayView
        }
        return JTSCalendarDayView()
    }
    
    // MARK:- Day View
    func prepareDayView(_ dayView:JTSCalendarDayView) {
        manager?.delegate?.calendar?(self.manager!, prepareDayView: dayView)
    }
    
    func didTouchDayView(_ dayView:JTSCalendarDayView){
        manager?.delegate?.calendar?(self.manager!, didTouchDayView: dayView)
    }
    

}
