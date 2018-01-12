//
//  JTSHorizontalCalendarView.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/9.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit

class JTSHorizontalCalendarView: JTSHVCalendarBaseView {
    
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
    private var pageMode: JTSCalendarPageMode?
    
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
        if size.width != lastSize.width {
            lastSize = size
            repositionViews()
        }
        else if size.height != lastSize.height {
            lastSize = size
            leftView?.frame = CGRect(x: leftView?.frame.origin.x ?? 0.0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: centerView?.frame.origin.x ?? 0.0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: rightView?.frame.origin.x ?? 0.0, y: 0, width: size.width, height: size.height)
            contentSize = CGSize(width: contentSize.width, height: size.height)
        }
        
    }
    
    func viewDidScroll() {
        if contentSize.width <= 0 {
            return
        }
        let size: CGSize = frame.size
        switch pageMode! {
        case .full:
            if contentOffset.x < size.width / 2.0 {
                loadPreviousPage()
            }
            else if contentOffset.x > size.width * 1.5 {
                loadNextPage()
            }
            
        case .center:
            break
        case .centerLeft:
            if contentOffset.x < size.width / 2.0 {
                loadPreviousPage()
            }
        case .centerRight:
            if contentOffset.x > size.width / 2.0 {
                loadNextPage()
            }
        }
        manager?.scrollManager?.updateMenuContentOffset(percentage: (contentOffset.x / contentSize.width), pageMode: pageMode!)
    }
    
    override func loadPreviousPageWithAnimation() {
        switch pageMode! {
        case .centerRight, .center:
            return
        default:
            break
        }
        let size: CGSize = frame.size
        let point = CGPoint(x: contentOffset.x - size.width, y: 0)
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
        let point = CGPoint(x: contentOffset.x + size.width, y: 0)
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
        let previousPageMode: JTSCalendarPageMode? = pageMode
        updatePageMode()
        let size: CGSize = frame.size
        switch pageMode! {
        case .full:
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width * 2, y: 0, width: size.width, height: size.height)
            if previousPageMode == .full {
                contentOffset = CGPoint(x: contentOffset.x + size.width, y: 0)
            }
            else if previousPageMode == .centerLeft {
                contentOffset = CGPoint(x: contentOffset.x + size.width, y: 0)
            }
            
            contentSize = CGSize(width: size.width * 3, height: size.height)
        case .center:
            // Not tested
            leftView?.frame = CGRect(x: -size.width, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            contentSize = size
        case .centerLeft:
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width * 2, y: 0, width: size.width, height: size.height)
            contentOffset = CGPoint(x: contentOffset.x + size.width, y: 0)
            contentSize = CGSize(width: size.width * 2, height: size.height)
        case .centerRight:
            leftView?.frame = CGRect(x: -size.width, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            contentSize = CGSize(width: size.width * 2, height: size.height)
        }
        // Update dayViews becuase current month changed
        rightView?.reload()
        centerView?.reload()
        manager?.delegate?.calendarDidLoadPreviousPage?(self.manager!)
//        if manager?.delegate && manager?.delegate.responds(to: #selector(self.calendarDidLoadPreviousPage)) {
//            manager?.delegate.calendarDidLoadPreviousPage(manager)
//        }
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
        let previousPageMode: JTSCalendarPageMode? = pageMode
        updatePageMode()
        let size: CGSize = frame.size
        switch pageMode! {
        case .full:
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width * 2, y: 0, width: size.width, height: size.height)
            if previousPageMode == .full {
                contentOffset = CGPoint(x: contentOffset.x - size.width, y: 0)
            }
            contentSize = CGSize(width: size.width * 3, height: size.height)
        case .center:
            // Not tested
            leftView?.frame = CGRect(x: -size.width, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            contentSize = size
        case .centerLeft:
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width * 2, y: 0, width: size.width, height: size.height)
            if previousPageMode != .centerRight {
                contentOffset = CGPoint(x: contentOffset.x - size.width, y: 0)
            }
            // Must be set a the end else the scroll freeze
            contentSize = CGSize(width: size.width * 2, height: size.height)
        case .centerRight:
            // Not tested
            leftView?.frame = CGRect(x: -size.width, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            contentSize = CGSize(width: size.width * 2, height: size.height)
        }
        // Update dayViews becuase current month changed
        leftView?.reload()
        centerView?.reload()
        manager?.delegate?.calendarDidLoadNextPage?(self.manager!)
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
            contentSize = CGSize(width: size.width * 3, height: size.height)
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width * 2, y: 0, width: size.width, height: size.height)
            contentOffset = CGPoint(x: size.width, y: 0)
        case .center:
            contentSize = size
            leftView?.frame = CGRect(x: -size.width, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            contentOffset = CGPoint.zero
        case .centerLeft:
            contentSize = CGSize(width: size.width * 2, height: size.height)
            leftView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width * 2, y: 0, width: size.width, height: size.height)
            contentOffset = CGPoint(x: size.width, y: 0)
        case .centerRight:
            contentSize = CGSize(width: size.width * 2, height: size.height)
            leftView?.frame = CGRect(x: -size.width, y: 0, width: size.width, height: size.height)
            centerView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rightView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            contentOffset = CGPoint.zero
        }
    }
    
    func updateMenuDates() {
        manager?.scrollManager?.setMenuPreviousDate(previousDate: (leftView?.date)!, currentDate: (centerView?.date)!, nextDate: (rightView?.date)!)
    }
}
