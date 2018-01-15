//
//  JTSCalendarMenuView.swift
//  JTCalendarSwift
//
//  Created by 刘振兴 on 2018/1/9.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit

open enum JTSCalendarPageMode : Int {
    case full
    case center
    case centerLeft
    case centerRight
}



open class JTSCalendarMenuView: UIView,JTSMenu,UIScrollViewDelegate {

    weak var manager: JTSCalendarManager?
    var contentRatio: CGFloat = 0.0
    var scrollView: UIScrollView?
    private var lastSize = CGSize.zero
    private var leftView: UIView?
    private var centerView: UIView?
    private var rightView: UIView?
    private var pageMode: JTSCalendarPageMode?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        self.clipsToBounds = true
        contentRatio = 1.0
        
        scrollView = UIScrollView()
        self.addSubview(scrollView!)
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.isPagingEnabled = true
        scrollView?.delegate = self
        scrollView?.clipsToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.resizeViewsIfWithChanged()
    }
    
    private func resizeViewsIfWithChanged() {
        let size = self.frame.size
        if size.width != lastSize.width {
            lastSize = size
            self.repositionViews()
        }else if(size.height != lastSize.height){
            lastSize = size
            scrollView?.frame = CGRect(x:(scrollView?.frame.origin.x)!,y: 0, width:(scrollView?.frame.size.width)!, height: size.height)
            scrollView?.contentSize = CGSize(width: (scrollView?.contentSize.width)!, height: size.height)
            leftView?.frame = CGRect(x: (leftView?.frame.origin.x)!, y: 0, width: (scrollView?.frame.size.width)!, height: size.height)
            centerView?.frame = CGRect(x: (centerView?.frame.origin.x)!, y: 0, width: (scrollView?.frame.size.width)!, height: size.height)
            rightView?.frame = CGRect(x: (rightView?.frame.origin.x)!, y: 0, width: (scrollView?.frame.size.width)!, height: size.height)
        }
    }
    
    private func repositionViews(){
        scrollView?.contentInset = .zero
        do {
            let width: CGFloat = frame.size.width * contentRatio
            let x: CGFloat = (frame.size.width - width) / 2.0
            let height: CGFloat = frame.size.height
            scrollView?.frame = CGRect(x: x, y: 0, width: width, height: height)
            scrollView?.contentSize = CGSize(width: width, height: height)
        }
        let size: CGSize? = scrollView?.frame.size
        switch pageMode! {
        case .full:
            scrollView?.contentSize = CGSize(width: (size?.width)! * 3, height: size?.height ?? 0.0)
            leftView?.frame = CGRect(x: 0, y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            centerView?.frame = CGRect(x: size?.width ?? 0.0, y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            rightView?.frame = CGRect(x: (size?.width)! * 2, y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            scrollView?.contentOffset = CGPoint(x: size?.width ?? 0.0, y: 0)
        case .center:
            scrollView?.contentSize = size!
            leftView?.frame = CGRect(x:-(size?.width ?? 0.0), y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            centerView?.frame = CGRect(x: 0, y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            rightView?.frame = CGRect(x: size?.width ?? 0.0, y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            scrollView?.contentOffset = CGPoint.zero
        case .centerLeft:
            scrollView?.contentSize = CGSize(width: (size?.width)! * 2, height: size?.height ?? 0.0)
            leftView?.frame = CGRect(x: 0, y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            centerView?.frame = CGRect(x: size?.width ?? 0.0, y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            rightView?.frame = CGRect(x: (size?.width)! * 2, y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            scrollView?.contentOffset = CGPoint(x: size?.width ?? 0.0, y: 0)
        case .centerRight:
            scrollView?.contentSize = CGSize(width: (size?.width)! * 2, height: size?.height ?? 0.0)
            leftView?.frame = CGRect(x: -(size?.width ?? 0.0), y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            centerView?.frame = CGRect(x: 0, y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            rightView?.frame = CGRect(x: size?.width ?? 0.0, y: 0, width: size?.width ?? 0.0, height: size?.height ?? 0.0)
            scrollView?.contentOffset = CGPoint.zero
        }
    }
    
    
    func setPreviousDate(previousDate: Date?, currentDate: Date?, nextDate: Date?) {
        assert(currentDate != nil, "currentDate cannot be nil")
        assert(manager != nil, "manager cannot be nil")
        if leftView == nil {
            leftView = manager?.delegateManager?.buildMenuItemView()
            scrollView?.addSubview(leftView!)
            centerView = manager?.delegateManager?.buildMenuItemView()
            scrollView?.addSubview(centerView!)
            rightView = manager?.delegateManager?.buildMenuItemView()
            scrollView?.addSubview(rightView!)
        }
        
        manager?.delegateManager?.prepareMenuItemView(leftView!, previousDate)
        manager?.delegateManager?.prepareMenuItemView(centerView!, currentDate)
        manager?.delegateManager?.prepareMenuItemView(rightView!, nextDate)
        
        let haveLeftPage:Bool = (manager?.delegateManager?.canDisplayPageWithDate(previousDate!))!
        let haveRightPage:Bool = (manager?.delegateManager?.canDisplayPageWithDate(nextDate!))!
        
        if (manager?.settings?.isPageViewHideWhenPossible)! {
            leftView?.isHidden = !haveLeftPage
            rightView?.isHidden = !haveRightPage
        }else{
            leftView?.isHidden = false
            rightView?.isHidden = false
        }
        
    }
    
    func updatePageMode(pageMode: JTSCalendarPageMode) {
        if self.pageMode == pageMode {
            return
        }
        self.pageMode = pageMode
        self.repositionViews()
    }
    
    
    

}
