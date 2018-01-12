//
//  JTSCalendarDelegateManager.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/7.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit
class JTSCalendarDelegateManager:NSObject {
    
    weak var manager: JTSCalendarManager?
    
    
    // MARK:- Menu View
    func buildMenuItemView() -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        return manager?.delegate?.calendarBuildMenuItemView?(self.manager!) ?? label
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
        return manager?.delegate?.calendarBuildPageView?(self.manager!) ?? JTSCalendarPageView()
    }
    
    func canDisplayPageWithDate(_ date:Date) -> Bool {
        return manager?.delegate?.calendar?(self.manager!, canDisplayPageWith: date) ?? true
    }
    
    //- (NSDate *)dateForPreviousPageWithCurrentDate:(NSDate *)currentDate
    func dateForPreviousPageWithCurrentDate(_ currentDate:Date?) -> Date{
        assert(currentDate != nil , "currentDate cannot be nil")
        return manager?.delegate?.calendar?(self.manager!, dateForPreviousPageWithCurrentDate: currentDate!) ?? (manager?.settings?.isWeekModeEnabled == true ? manager?.dateHelper?.addToDate(currentDate!, weeks: -1) : manager?.dateHelper?.addToDate(currentDate!, months: -1))!
    }
    //- (NSDate *)dateForNextPageWithCurrentDate:(NSDate *)currentDate
    func dateForNextPageWithCurrentDate(_ currentDate:Date?) -> Date{
        assert(currentDate != nil , "currentDate cannot be nil")
        return manager?.delegate?.calendar?(self.manager!, dateForNextPageWithCurrentDate:currentDate!) ?? (manager?.settings?.isWeekModeEnabled == true ? manager?.dateHelper?.addToDate(currentDate!, weeks: -1) : manager?.dateHelper?.addToDate(currentDate!, months: -1))!
    }
    
    // MARK:- page View
    func buildWeekDayView() -> JTSCalendarWeekDayView {
        return manager?.delegate?.calendarBuildWeekDayView?(self.manager!) ?? JTSCalendarWeekDayView()
    }
    
    func buildWeekView() -> JTSCalendarWeekView {
        return manager?.delegate?.calendarBuildWeekView?(self.manager!) ?? JTSCalendarWeekView()
    }
    
    // MARK:- Week View
    func buildDayView() -> JTSCalendarDayView {
        return manager?.delegate?.calendarBuildDayView?(self.manager!) ?? JTSCalendarDayView()
    }
    
    // MARK:- Day View
    func prepareDayView(_ dayView:JTSCalendarDayView) {
        manager?.delegate?.calendar?(self.manager!, prepareDayView: dayView)
    }
    
    func didTouchDayView(_ dayView:JTSCalendarDayView){
        manager?.delegate?.calendar?(self.manager!, didTouchDayView: dayView)
    }
    

}
