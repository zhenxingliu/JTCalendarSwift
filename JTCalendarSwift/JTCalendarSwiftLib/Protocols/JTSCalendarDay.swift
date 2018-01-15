//
//  JTSCalendarDay.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/7.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit
public protocol JTSCalendarDay:NSObjectProtocol {
    var date:Date? { get set }
    var isFromAnotherMonth:Bool { get set }
    var manager:JTSCalendarManager? { get set }
}
