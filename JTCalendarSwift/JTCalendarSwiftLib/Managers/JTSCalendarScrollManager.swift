//
//  JTSCalendarScrollManager.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/7.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit

class JTSCalendarScrollManager:NSObject {
    
    weak var manager:JTSCalendarManager?
    
    weak var menuView:JTSCalendarMenuView?
    
    weak var horizontalContentView:JTSHorizontalCalendarView?
    
    func setMenuPreviousDate(previousDate:Date,currentDate:Date,nextDate:Date){
        if menuView == nil {
            return
        }
        menuView?.setPreviousDate(previousDate: previousDate, currentDate: currentDate, nextDate: nextDate)
    }
    
    func updateMenuContentOffset(percentage:CGFloat,pageMode:JTSCalendarPageMode){
        if menuView ==  nil {
            return
        }
        menuView?.updatePageMode(pageMode: pageMode)
        menuView?.scrollView?.contentOffset = CGPoint(x: percentage * (menuView?.scrollView?.contentSize.width)!, y: 0)
    }
    
    func updateHorizontalContentOffset(percentage:CGFloat){
        if horizontalContentView == nil {
            return
        }
        horizontalContentView?.contentOffset = CGPoint(x: percentage * (horizontalContentView?.contentSize.width)!, y: 0)
    }
}
