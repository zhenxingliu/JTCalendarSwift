//  Converted to Swift 4 by Swiftify v1.0.6577 - https://objectivec2swift.com/
//
//  JTSCalendarDelegate.h
//  JTSCalendar
//
//  Created by Jonathan Tribouharet
//

import UIKit

@objc protocol JTSCalendarDelegate: NSObjectProtocol {
    // Menu view
    /*!
     * Provide a UIView, used as page for the menuView.
     * Return an instance of `UILabel` by default.
     */
    @objc optional func calendarBuildMenuItemView(_ calendar: JTSCalendarManager) -> UIView
    
    /*!
     * Used to customize the menuItemView.
     * Set text attribute to the name of the month by default.
     */
    @objc optional func calendar(_ calendar: JTSCalendarManager, prepareMenuItemView menuItemView: UIView, date: Date)
    
    // Content view
    /*!
     * Indicate if the calendar can go to this date.
     * Return `YES` by default.
     */
    @objc optional func calendar(_ calendar: JTSCalendarManager, canDisplayPageWith date: Date) -> Bool
    
    /*!
     * Provide the date for the previous page.
     * Return 1 month before the current date by default.
     */
    @objc optional func calendar(_ calendar: JTSCalendarManager, dateForPreviousPageWithCurrentDate currentDate: Date) -> Date
    
    /*!
     * Provide the date for the next page.
     * Return 1 month after the current date by default.
     */
    @objc optional func calendar(_ calendar: JTSCalendarManager, dateForNextPageWithCurrentDate currentDate: Date) -> Date
    
    /*!
     * Indicate the previous page became the current page.
     */
    @objc optional func calendarDidLoadPreviousPage(_ calendar: JTSCalendarManager)
    
    /*!
     * Indicate the next page became the current page.
     */
    @objc optional func calendarDidLoadNextPage(_ calendar: JTSCalendarManager)
    
    /*!
     * Provide a view conforming to `JTSCalendarPage` protocol, used as page for the contentView.
     * Return an instance of `JTSCalendarPageView` by default.
     */
    @objc optional func calendarBuildPageView(_ calendar: JTSCalendarManager) -> JTSCalendarPageView
    
    // Page view
    /*!
     * Provide a view conforming to `JTSCalendarWeekDay` protocol.
     * Return an instance of `JTSCalendarWeekDayView` by default.
     */
    @objc optional func calendarBuildWeekDayView(_ calendar: JTSCalendarManager) -> JTSCalendarWeekDayView
    
    /*!
     * Provide a view conforming to `JTSCalendarWeek` protocol.
     * Return an instance of `JTSCalendarWeekView` by default.
     */
    @objc optional func calendarBuildWeekView(_ calendar: JTSCalendarManager) -> JTSCalendarWeekView
    
    // Week view
    /*!
     * Provide a view conforming to `JTSCalendarDay` protocol.
     * Return an instance of `JTSCalendarDayView` by default.
     */
    @objc optional func calendarBuildDayView(_ calendar: JTSCalendarManager) -> JTSCalendarDayView
    
    // Day view
    /*!
     * Used to customize the dayView.
     */
    @objc optional func calendar(_ calendar: JTSCalendarManager, prepareDayView dayView: JTSCalendarDayView)
    
    /*!
     * Indicate the dayView just get touched.
     */
    @objc optional func calendar(_ calendar: JTSCalendarManager, didTouchDayView dayView: JTSCalendarDayView)
}
