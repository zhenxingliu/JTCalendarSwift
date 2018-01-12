//
//  JTSCalendarDayView.swift
//  JTSCalendarSwift
//
//  Created by 刘振兴 on 2018/1/8.
//  Copyright © 2018年 zoneland. All rights reserved.
//

import UIKit

class JTSCalendarDayView: UIView, JTSCalendarDay {
    
    weak var manager: JTSCalendarManager?
    
    private var _date: Date?
    
    var date: Date? {
        get {
            return _date
        }
        set(date) {
            assert(date != nil, "date cannot be nil")
            assert(manager != nil, "manager cannot be nil")
            _date = date
            reload()
        }
    }
    
    private(set) var circleView: UIView?
    
    private(set) var dotView: UIView?
    
    private(set) var textLabel: UILabel?
    
    var circleRatio: CGFloat = 0.0
    
    var dotRatio: CGFloat = 0.0
    
    var isFromAnotherMonth = false
    
    /*!
     * Must be call if override the class
     */
    func commonInit() {
        clipsToBounds = true
        circleRatio = 0.9
        dotRatio = 1.0 / 9.0
        do {
            circleView = UIView()
            addSubview(circleView ?? UIView())
            circleView?.backgroundColor = UIColor(red: 0x33 / 256.0, green: 0xb3 / 256.0, blue: 0xec / 256.0, alpha: 0.5)
            circleView?.isHidden = true
            circleView?.layer.rasterizationScale = UIScreen.main.scale
            circleView?.layer.shouldRasterize = true
        }
        do {
            dotView = UIView()
            addSubview(dotView ?? UIView())
            dotView?.backgroundColor = UIColor.red
            dotView?.isHidden = true
            dotView?.layer.rasterizationScale = UIScreen.main.scale
            dotView?.layer.shouldRasterize = true
        }
        do {
            textLabel = UILabel()
            addSubview(textLabel ?? UIView())
            textLabel?.textColor = UIColor.black
            textLabel?.textAlignment = .center
            textLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        do {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didTouch))
            isUserInteractionEnabled = true
            addGestureRecognizer(gesture)
        }
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
        super.layoutSubviews()
        textLabel?.frame = bounds
        var sizeCircle: CGFloat = min(frame.size.width, frame.size.height)
        var sizeDot: CGFloat = sizeCircle
        sizeCircle = sizeCircle * circleRatio
        sizeDot = sizeDot * dotRatio
        sizeCircle = CGFloat(roundf(Float(sizeCircle)))
        sizeDot = CGFloat(roundf(Float(sizeDot)))
        circleView?.frame = CGRect(x: 0, y: 0, width: sizeCircle, height: sizeCircle)
        circleView?.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        circleView?.layer.cornerRadius = sizeCircle / 2.0
        dotView?.frame = CGRect(x: 0, y: 0, width: sizeDot, height: sizeDot)
        dotView?.center = CGPoint(x: frame.size.width / 2.0, y: (frame.size.height / 2.0) + sizeDot * 2.5)
        dotView?.layer.cornerRadius = sizeDot / 2.0
    }
    
    func reload() {
        var dateFormatter: DateFormatter? = nil
        if dateFormatter == nil {
            dateFormatter = manager?.dateHelper?.createDateFormatter()
        }
        dateFormatter?.dateFormat = dayFormat()
        textLabel?.text = dateFormatter?.string(from: date!)
        manager?.delegateManager?.prepareDayView(self)
    }
    
    @objc func didTouch() {
        manager?.delegateManager?.didTouchDayView(self)
    }
    
    func dayFormat() -> String {
        return (manager?.settings?.isZeroPaddedDayFormat)! ? "dd" : "d"
    }
}
