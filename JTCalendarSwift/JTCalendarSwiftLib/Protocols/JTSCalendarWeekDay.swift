//
//  JTSCalendarWeekDay.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/7.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import Foundation
open protocol JTSCalendarWeekDay:NSObjectProtocol {
    var manager:JTSCalendarManager? { get set }
    func reload()
}
