//
//  JTSVerticalCalendarView.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/9.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit

class JTSVerticalCalendarView: JTSHVCalendarBaseView {
    
    private weak var _manager: JTSCalendarManager?
    override weak var manager: JTSCalendarManager? {
        get {
            return _manager
        }
        set(manager) {
            _manager = manager
            updateManagerForViews()
        }
    }
    
    private var _date: Date?
    override var date: Date? {
        get {
            return _date
        }
        set(date) {
            assert(date != nil, "date cannot be nil")
            assert(manager != nil, "manager cannot be nil")
            _date = date
            if leftView == nil {
                leftView = manager?.delegateManager?.buildPageView()
                addSubview(leftView!)
                centerView = manager?.delegateManager?.buildPageView()
                addSubview(centerView!)
                rightView = manager?.delegateManager?.buildPageView()
                addSubview(rightView!)
                updateManagerForViews()
            }
            leftView?.date = manager?.delegateManager?.dateForPreviousPageWithCurrentDate(date)
            centerView?.date = date
            rightView?.date = manager?.delegateManager?.dateForNextPageWithCurrentDate(date)
            updateMenuDates()
            updatePageMode()
            repositionViews()
        }
    }
    
    private var lastSize = CGSize.zero
    private weak var leftView: JTSCalendarPageView?
    private weak var centerView: JTSCalendarPageView?
    private weak var rightView: JTSCalendarPageView?
    private var pageMode:JTSCalendarPageMode?
    
    /*!
     * Must be call if override the class
     */
    func commonInit() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isPagingEnabled = true
        clipsToBounds = true
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
        resizeViewsIfWidthChanged()
        viewDidScroll()
    }
    
    func resizeViewsIfWidthChanged() {
        let size: CGSize = frame.size
        if size.height != lastSize.height {
            lastSize = size
            repositionViews()
        }
        else if size.width != lastSize.width {
            lastSize = size
            leftView?.frame = CGRect(x: 0, y: leftView?.frame.origin.y ?? 0.0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: centerView?.frame.origin.y ?? 0.0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: rightView?.frame.origin.y ?? 0.0, width: size.width, height: size.height)
            contentSize = CGSize(width: size.width, height: contentSize.height)
        }
        
    }
    
    func viewDidScroll() {
        if contentSize.height <= 0 {
            return
        }
        let size: CGSize = frame.size
        switch pageMode! {
        case .full:
            if contentOffset.y < size.height / 2.0 {
                loadPreviousPage()
            }
            else if contentOffset.y > size.height * 1.5 {
                loadNextPage()
            }
            
        case .center:
            break
        case .centerLeft:
            if contentOffset.y < size.height / 2.0 {
                loadPreviousPage()
            }
        case .centerRight:
            if contentOffset.y > size.height / 2.0 {
                loadNextPage()
            }
        }
        manager?.scrollManager?.updateMenuContentOffset(percentage: (contentOffset.y / contentSize.height), pageMode: pageMode!)
    }
    
    override func loadPreviousPageWithAnimation() {
        switch pageMode! {
        case .centerRight, .center:
            return
        default:
            break
        }
        let size: CGSize = frame.size
        let point = CGPoint(x: 0, y: contentOffset.y - size.height)
        setContentOffset(point, animated: true)
    }
    
    override func loadNextPageWithAnimation() {
        switch pageMode! {
        case .centerLeft, .center:
            return
        default:
            break
        }
        let size: CGSize = frame.size
        let point = CGPoint(x: 0, y: contentOffset.y + size.height)
        setContentOffset(point, animated: true)
    }
    
    
    override func loadPreviousPage() {
        let nextDate: Date? = manager?.delegateManager?.dateForPreviousPageWithCurrentDate(leftView?.date)
        // Must be set before chaging date for PageView for updating day views
        date = leftView?.date
        let tmpView: JTSCalendarPageView? = rightView
        rightView = centerView
        centerView = leftView
        leftView = tmpView
        leftView?.date = nextDate
        updateMenuDates()
        let previousPageMode: JTSCalendarPageMode = pageMode!
        updatePageMode()
        let size: CGSize = frame.size
        switch pageMode! {
        case .full:
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height * 2, width: size.width, height: size.height)
            if previousPageMode == .full {
                contentOffset = CGPoint(x: 0, y: contentOffset.y + size.height)
            }
            else if previousPageMode == .centerLeft {
                contentOffset = CGPoint(x: 0, y: contentOffset.y + size.height)
            }
            
            contentSize = CGSize(width: size.width, height: size.height * 3)
        case .center:
            // Not tested
            leftView?.frame = CGRect(x: 0, y: -size.height, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            contentSize = size
        case .centerLeft:
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height * 2, width: size.width, height: size.height)
            contentOffset = CGPoint(x: 0, y: contentOffset.y + size.height)
            contentSize = CGSize(width: size.width, height: size.height * 2)
        case .centerRight:
            leftView?.frame = CGRect(x: 0, y: -size.height, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            contentSize = CGSize(width: size.width, height: size.height * 2)
        }
        // Update subviews
        rightView?.reload()
        centerView?.reload()
//        if manager?.delegate && manager?.delegate.responds(to: #selector(self.calendarDidLoadPreviousPage)) {
//            manager?.delegate.calendarDidLoadPreviousPage(manager)
//        }
        manager?.delegate?.calendarDidLoadPreviousPage?(self.manager!)
    }
    
    override func loadNextPage() {
        let nextDate: Date? = manager?.delegateManager?.dateForNextPageWithCurrentDate(rightView?.date)
        // Must be set before chaging date for PageView for updating day views
        date = rightView?.date
        let tmpView: JTSCalendarPageView? = leftView
        leftView = centerView
        centerView = rightView
        rightView = tmpView
        rightView?.date = nextDate
        updateMenuDates()
        let previousPageMode: JTSCalendarPageMode = pageMode!
        updatePageMode()
        let size: CGSize = frame.size
        switch pageMode! {
        case .full:
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height * 2, width: size.width, height: size.height)
            if previousPageMode == .full {
                contentOffset = CGPoint(x: 0, y: contentOffset.y - size.height)
            }
            contentSize = CGSize(width: size.width, height: size.height * 3)
        case .center:
            // Not tested
            leftView?.frame = CGRect(x: 0, y: -size.height, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            contentSize = size
        case .centerLeft:
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height * 2, width: size.width, height: size.height)
            if previousPageMode != .centerRight {
                //                self.contentOffset = CGPointMake(0, self.contentOffset.x - size.width);
            }
            // Must be set a the end else the scroll freeze
            contentSize = CGSize(width: size.width, height: size.height * 2)
        case .centerRight:
            // Not tested
            leftView?.frame = CGRect(x: 0, y: -size.height, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            contentSize = CGSize(width: size.width, height: size.height * 2)
        }
        // Update subviews
        leftView?.reload()
        centerView?.reload()
//        if manager?.delegate && manager?.delegate.responds(to: #selector(self.calendarDidLoadNextPage)) {
//            manager?.delegate.calendarDidLoadNextPage(manager)
//        }
        
    }
    
    func updateManagerForViews() {
        if !((manager != nil) || !(leftView != nil)) {
            return
        }
        leftView?.manager = manager
        centerView?.manager = manager
        rightView?.manager = manager
    }
    
    func updatePageMode() {
        let haveLeftPage: Bool = (manager?.delegateManager?.canDisplayPageWithDate((leftView?.date)!))!
        let haveRightPage: Bool = (manager?.delegateManager?.canDisplayPageWithDate((rightView?.date)!))!
        if haveLeftPage && haveRightPage {
            pageMode = .full
        }
        else if !(haveLeftPage && !haveRightPage) {
            pageMode = .center
        }
        else if !(haveLeftPage) {
            pageMode = .centerRight
        }
        else {
            pageMode = .centerLeft
        }
        
        if (manager?.settings?.isPageViewHideWhenPossible)! {
            leftView?.isHidden = !haveLeftPage
            rightView?.isHidden = !haveRightPage
        }
        else {
            leftView?.isHidden = false
            rightView?.isHidden = false
        }
    }
    
    func repositionViews() {
        let size: CGSize = frame.size
        contentInset = .zero
        switch pageMode! {
        case .full:
            contentSize = CGSize(width: size.width, height: size.height * 3)
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height * 2, width: size.width, height: size.height)
            contentOffset = CGPoint(x: 0, y: size.height)
        case .center:
            contentSize = size
            leftView?.frame = CGRect(x: 0, y: -size.height, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            contentOffset = CGPoint.zero
        case .centerLeft:
            contentSize = CGSize(width: size.width, height: size.height * 2)
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height * 2, width: size.width, height: size.height)
            contentOffset = CGPoint(x: 0, y: size.height)
        case .centerRight:
            contentSize = CGSize(width: size.width, height: size.height * 2)
            leftView?.frame = CGRect(x: 0, y: -size.height, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            contentOffset = CGPoint.zero
        }
    }
    
    func updateMenuDates() {
        manager?.scrollManager?.setMenuPreviousDate(previousDate: (leftView?.date)!, currentDate: (centerView?.date)!, nextDate: (rightView?.date)!)
    }
    
    
    
}
