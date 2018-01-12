//
//  JTSMenu.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/7.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit
protocol  JTSMenu:NSObjectProtocol {
    
    var manager:JTSCalendarManager? { get set}
    
    var scrollView:UIScrollView? { get set }
    
    func setPreviousDate(previousDate:Date?,currentDate:Date?,nextDate:Date?)
    
    func updatePageMode(pageMode:JTSCalendarPageMode)
   
}
