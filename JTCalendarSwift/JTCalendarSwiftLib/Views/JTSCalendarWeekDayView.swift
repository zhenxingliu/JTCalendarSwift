//
//  JTSCalendarWeekDayView.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/9.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit

open class JTSCalendarWeekDayView: UIView, JTSCalendarWeekDay {
    
    weak var manager: JTSCalendarManager?
    
    private(set) var dayViews = [UIView]()
    
    /*!
     * Must be call if override the class
     */
    func commonInit() {
        var dayViews = [UIView]()
        for _ in 0..<NUMBER_OF_DAY_BY_WEEK {
            let label = UILabel()
            addSubview(label)
            dayViews.append(label)
            label.textAlignment = .center
            label.textColor = UIColor(red: 152.0 / 256.0, green: 147.0 / 256.0, blue: 157.0 / 256.0, alpha: 1.0)
            label.font = UIFont.systemFont(ofSize: 11)
        }
        self.dayViews = dayViews
    }
    
    /*!
     * Rebuild the view, must be call if you change `weekDayFormat` or `firstWeekday`
     */
    func reload() {
        assert(manager != nil, "manager cannot be nil")
        let dateFormatter = manager?.dateHelper?.createDateFormatter()
        var days: [Any]? = nil
        dateFormatter?.timeZone = manager?.dateHelper?.calendar.timeZone
        dateFormatter?.locale = manager?.dateHelper?.calendar.locale!
        switch (manager?.settings?.weekDayFormat)! {
        case .single:
            days = dateFormatter?.veryShortStandaloneWeekdaySymbols
        case .short:
            days = dateFormatter?.shortStandaloneWeekdaySymbols
        case .full:
            days = dateFormatter?.standaloneWeekdaySymbols
        }
        for i in 0..<(days?.count)! {
            let day = days![i] as? String
            days?[i] = day?.uppercased() ?? ""
        }
        // Redorder days for be conform to calendar
        do {
            let calendar: Calendar? = manager?.dateHelper?.calendar
            let firstWeekday: Int = ((calendar?.firstWeekday)! + 6) % 7
            // Sunday == 1, Saturday == 7
            for _ in 0..<firstWeekday {
                let day = days?.first
                days?.remove(at: 0)
                days?.append(day ?? 0)
            }
        }
        for i in 0..<NUMBER_OF_DAY_BY_WEEK {
            let label = dayViews[i] as? UILabel
            label?.text = days![i] as? String
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if dayViews.isEmpty {
            return
        }
        var x: CGFloat = 0
        let dayWidth: CGFloat = frame.size.width / CGFloat(NUMBER_OF_DAY_BY_WEEK)
        let dayHeight: CGFloat = frame.size.height
        for dayView: UIView in dayViews {
            dayView.frame = CGRect(x: x, y: 0, width: dayWidth, height: dayHeight)
            x += dayWidth
        }
    }
}

let NUMBER_OF_DAY_BY_WEEK = 7
