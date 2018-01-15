//
//  JTSHVCalendarBaseView.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/11.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit

open class JTSHVCalendarBaseView: UIScrollView,JTSContent {
    
    weak public var manager: JTSCalendarManager?
    
    public var date: Date?
    
    open func loadPreviousPage() {
       fatalError("loadPreviousPage未实现")
    }
    
    open func loadNextPage() {
        fatalError("loadNextPage未实现")
    }
    
    open func loadPreviousPageWithAnimation() {
        fatalError("loadPreviousPageWithAnimation未实现")
    }
    
    open func loadNextPageWithAnimation() {
        fatalError("loadNextPageWithAnimation未实现")
    }
    

}
