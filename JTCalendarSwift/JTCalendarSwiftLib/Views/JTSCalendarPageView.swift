//
//  JTSCalendarPageView.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/9.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit

let MAX_WEEKS_BY_MONTH = 6

class JTSCalendarPageView: UIView,JTSCalendarPage {
    
    weak var manager: JTSCalendarManager?
    
    private var _date: Date?
    var date: Date? {
        get {
            return _date
        }
        set(date) {
            assert(manager != nil, "manager cannot be nil")
            assert(date != nil, "date cannot be nil")
            _date = date
            reload()
        }
    }
    
    private weak var weekDayView:JTSCalendarWeekDayView?
    private var weeksViews = [UIView]()
    private var numberOfWeeksDisplayed: Int = 0
    
    /*!
     * Must be call if override the class
     */
    func commonInit() {
        // Maybe used in future
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func reload() {
        if (manager?.settings?.isPageViewHaveWeekDaysView)! && weekDayView != nil {
            weekDayView = manager?.delegateManager?.buildWeekDayView()
            addSubview(weekDayView!)
        }
        weekDayView?.manager = self.manager
        weekDayView?.reload()
        if weeksViews.isEmpty {
            weeksViews = [UIView]()
            for _ in 0..<MAX_WEEKS_BY_MONTH {
                let weekView: JTSCalendarWeekView? = manager?.delegateManager?.buildWeekView()
                weeksViews.append(weekView!)
                addSubview(weekView!)
                weekView?.manager = manager
            }
        }
        var weekDate: Date? = nil
        if (manager?.settings?.isWeekModeEnabled)! {
            numberOfWeeksDisplayed = min(max((manager?.settings?.pageViewWeekModeNumberOfWeeks)!, 1), MAX_WEEKS_BY_MONTH)
            weekDate = manager?.dateHelper?.firstWeekDayOfWeek(date!)
        }
        else {
            numberOfWeeksDisplayed = min((manager?.settings?.pageViewNumberOfWeeks)!, MAX_WEEKS_BY_MONTH)
            if numberOfWeeksDisplayed == 0 {
                numberOfWeeksDisplayed = Int(manager?.dateHelper?.numberOfWeeks(date!) ?? 0)
            }
            weekDate = manager?.dateHelper?.firstWeekDayOfMonth(date!)
        }
        for i in 0..<numberOfWeeksDisplayed {
            let weekView = weeksViews[i] as? JTSCalendarWeekView
            weekView?.isHidden = false
            // Process the check on another month for the 1st, 4th and 5th weeks
            if i == 0 || i >= 4 {
                weekView?.setStartDate(weekDate!, updateAnotherMonth: true, monthDate: date!)
            }
            else {
                weekView?.setStartDate(weekDate!, updateAnotherMonth: false, monthDate: date!)
            }
            weekDate = manager?.dateHelper?.addToDate(weekDate!, weeks: 1)
        }
        for i in numberOfWeeksDisplayed..<MAX_WEEKS_BY_MONTH {
            let weekView = weeksViews[i] as?  JTSCalendarWeekView
            weekView?.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if weeksViews.isEmpty {
            return
        }
        var y: CGFloat = 0
        let weekWidth: CGFloat = frame.size.width
        if (manager?.settings?.isPageViewHaveWeekDaysView)! {
            var weekDayHeight: CGFloat? = weekDayView?.frame.size.height
            // Force use default height
            // Or use the same height than weeksViews
            if weekDayHeight == 0 || (manager?.settings?.isPageViewWeekDaysViewAutomaticHeight)! {
                weekDayHeight = CGFloat((frame.size.height/CGFloat(numberOfWeeksDisplayed + 1)))
            }
            weekDayView?.frame = CGRect(x: 0, y: 0, width: weekWidth, height: weekDayHeight ?? 0.0)
            y = weekDayHeight ?? 0.0
        }
        let weekHeight: CGFloat = (frame.size.height - y) / CGFloat(numberOfWeeksDisplayed)
        for weekView: UIView in weeksViews {
            weekView.frame = CGRect(x: 0, y: y, width: weekWidth, height: weekHeight)
            y += weekHeight
        }
    }

}
