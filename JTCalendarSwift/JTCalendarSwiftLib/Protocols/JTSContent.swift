//
//  JTSContent.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/7.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit
protocol JTSContent:NSObjectProtocol {
    
    var manager:JTSCalendarManager? { get set }
    
    var date:Date? { get  set }
    
    func loadPreviousPage()
    
    func loadNextPage()
    
    func loadPreviousPageWithAnimation()
    
    func loadNextPageWithAnimation()
}
