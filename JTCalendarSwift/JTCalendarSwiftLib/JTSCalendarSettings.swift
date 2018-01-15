import Foundation

open enum JTSCalendarWeekDayFormat : Int {
    case single
    case short
    case full
}


open class JTSCalendarSettings: NSObject {
    // Content view
    
    var isPageViewHideWhenPossible = false
    var isWeekModeEnabled = false
    // Page view
    // Must be less or equalt to 6, 0 for automatic
    var pageViewNumberOfWeeks: Int = 0
    var isPageViewHaveWeekDaysView = false
    var pageViewWeekModeNumberOfWeeks: Int = 0
    var isPageViewWeekDaysViewAutomaticHeight = false
    // WeekDay view
    var weekDayFormat: JTSCalendarWeekDayFormat?
    // Day view
    var isZeroPaddedDayFormat = false
    
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
    
    override init() {
        super.init()
        commonInit()
    }
}
