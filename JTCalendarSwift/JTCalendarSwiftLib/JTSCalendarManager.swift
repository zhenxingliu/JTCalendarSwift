//  Converted to Swift 4 by Swiftify v1.0.6577 - https://objectivec2swift.com/
import UIKit

class JTSCalendarManager: NSObject {
    
    weak var delegate: JTSCalendarDelegate?
    
    private weak var _menuView: JTSCalendarMenuView?
    
    weak var menuView: JTSCalendarMenuView? {
        get {
            return _menuView
        }
        set(menuView) {
            _menuView?.manager = nil
            _menuView = menuView
            _menuView?.manager = self
            scrollManager?.menuView = _menuView
        }
    }
    private weak var _contentView: JTSHVCalendarBaseView?
    
    weak var contentView: JTSHVCalendarBaseView? {
        get {
            return _contentView
        }
        set(contentView) {
            _contentView?.manager = nil
            _contentView = contentView
            _contentView?.manager = self
            // Can only synchronise JTHorizontalCalendarView
            if (_contentView is JTSHorizontalCalendarView) {
                scrollManager?.horizontalContentView = _contentView as? JTSHorizontalCalendarView
            }
            else {
                scrollManager?.horizontalContentView = nil
            }
        }
    }
    private(set) var dateHelper: JTSDateHelper?
    private(set) var settings: JTSCalendarSettings?
    // Intern methods
    private(set) var delegateManager: JTSCalendarDelegateManager?
    private(set) var scrollManager: JTSCalendarScrollManager?
    
    // Use for override
    func commonInit() {
        dateHelper = JTSDateHelper()
        settings = JTSCalendarSettings()
        delegateManager = JTSCalendarDelegateManager()
        delegateManager?.manager = self
        scrollManager = JTSCalendarScrollManager()
        scrollManager?.manager = self
    }
    
    func date() -> Date {
        return _contentView!.date!
    }
    
    func setDate(_ date: Date) {
        _contentView?.date = date
    }
    
    func reload() {
        contentView?.date = contentView?.date
    }
    
    override init() {
        super.init()
        commonInit()
    }
}

//
//  JTSCalendarManager.m
//  JTSCalendar
//
//  Created by Jonathan Tribouharet
//
