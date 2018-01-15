//
//  JTSCalendarWeekView.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/9.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit

open class JTSCalendarWeekView: UIView, JTSCalendarWeek {
    
    weak public var manager: JTSCalendarManager?
    
    public var startDate: Date?
    
    private var daysViews = [JTSCalendarDayView]()
    
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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func setStartDate(_ startDate: Date?, updateAnotherMonth enable: Bool, monthDate: Date?) {
        assert(startDate != nil, "startDate cannot be nil")
        assert(manager != nil, "manager cannot be nil")
        if enable {
            assert(monthDate != nil, "monthDate cannot be nil")
        }
        self.startDate = startDate
        createDayViews()
        reloadAndUpdateAnotherMonth(enable, monthDate: monthDate!)
    }
    
    func reloadAndUpdateAnotherMonth(_ enable: Bool, monthDate: Date) {
        var dayDate: Date? = startDate
        for dayView: JTSCalendarDayView in daysViews  {
            // Must done before setDate to dayView for `prepareDayView` method
            if !enable {
                dayView.isFromAnotherMonth = false
            }
            else {
                if (manager?.dateHelper?.isTheSameMonthThan(dayDate!, monthDate))! {
                    dayView.isFromAnotherMonth = false
                }
                else {
                    dayView.isFromAnotherMonth = true
                }
            }
            dayView.date = dayDate
            dayDate = manager?.dateHelper?.addToDate(dayDate!, days: 1)
        }
    }
    
    func createDayViews() {
        if daysViews.isEmpty {
            daysViews = [JTSCalendarDayView]()
            for _ in 0..<NUMBER_OF_DAY_BY_WEEK {
                let dayView: JTSCalendarDayView = (manager?.delegateManager?.buildDayView())!
                daysViews.append(dayView)
                addSubview(dayView)
                dayView.manager = manager
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if daysViews.isEmpty {
            return
        }
        var x: CGFloat = 0
        let dayWidth: CGFloat = frame.size.width / CGFloat(NUMBER_OF_DAY_BY_WEEK)
        let dayHeight: CGFloat = frame.size.height
        for dayView: UIView in daysViews {
            dayView.frame = CGRect(x: x, y: 0, width: dayWidth, height: dayHeight)
            x += dayWidth
        }
    }
}

