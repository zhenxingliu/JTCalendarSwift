import Foundation

public enum JTSCalendarWeekDayFormat : Int {
    case single
    case short
    case full
}


public class JTSCalendarSettings: NSObject {
    // Content view
    
    public var isPageViewHideWhenPossible = false
    public var isWeekModeEnabled = false
    // Page view
    // Must be less or equalt to 6, 0 for automatic
    public var pageViewNumberOfWeeks: Int = 0
    public var isPageViewHaveWeekDaysView = false
    public var pageViewWeekModeNumberOfWeeks: Int = 0
    public var isPageViewWeekDaysViewAutomaticHeight = false
    // WeekDay view
    public var weekDayFormat: JTSCalendarWeekDayFormat?
    // Day view
    public var isZeroPaddedDayFormat = false
    
    // Use for override
    func commonInit() {
        isPageViewHideWhenPossible = false
        pageViewNumberOfWeeks = 6
        isPageViewHaveWeekDaysView = true
        isPageViewWeekDaysViewAutomaticHeight = false
        weekDayFormat = .short
        isZeroPaddedDayFormat = true
        isWeekModeEnabled = false
        pageViewWeekModeNumberOfWeeks = 1
    }
    
    override public init() {
        super.init()
        commonInit()
    }
}
