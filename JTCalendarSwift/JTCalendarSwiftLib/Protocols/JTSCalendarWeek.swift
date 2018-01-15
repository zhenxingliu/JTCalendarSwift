//
//  JTSCalendarWeek.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/7.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import Foundation
open protocol JTSCalendarWeek:NSObjectProtocol {
    
    var manager:JTSCalendarManager? { get set }
    
    var startDate:Date? { get }
    
    func setStartDate(_ startDate:Date?,updateAnotherMonth:Bool,monthDate:Date?)
}
