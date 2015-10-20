//
//  ViewController.swift
//  CVCalendar Demo
//
//  Created by Мак-ПК on 1/3/15.
//  Copyright (c) 2015 GameApp. All rights reserved.
//

import UIKit
import CVCalendar
import CoreData

class CalenderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dailyDiaryTableView: UITableView!
    
    var ifCellRegistered = false
    let managedContext = DataController().managedObjectContext
    var messages = [NSManagedObject]()
    //var dailyDiary = [NSManagedObject]()
    var cellDataArray = [ChatBubbleCellData]()
    // MARK: - Properties
    
    
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthLabelView: UIImageView!
    //@IBOutlet weak var daysOutSwitch: UISwitch!
    
    @IBOutlet var frameView: UIView!
    
    internal var shouldShowDaysOut = true
    internal var animationFinished = true
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableViewFrame()
        updateCalendarFrame()
        loadDiaryData()
        findDiaryOnDate(NSDate())
        self.dailyDiaryTableView.delegate = self
        self.dailyDiaryTableView.dataSource = self
        
        self.dailyDiaryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.dailyDiaryTableView.showsVerticalScrollIndicator = false
        
        
    }
    
    
    func updateTableViewFrame(){
        
        let verticleOffset = 66 + calendarView.frame.height + menuView.frame.height + monthLabelView.frame.height
        
        dailyDiaryTableView.frame = CGRect(x: 40, y: verticleOffset , width: frameView.frame.width - 80, height: frameView.frame.height - verticleOffset - 44 )
        //self.frameView.addSubview(dailyDiaryTableView)
        print(dailyDiaryTableView.frame.origin.x, dailyDiaryTableView.frame.origin.y, dailyDiaryTableView.frame.width, dailyDiaryTableView.frame.height)
        //dailyDiaryTableView.layer.zPosition = 1
        
    }

    
   func updateCalendarFrame(){
    
    monthLabelView.frame = CGRect(x: 0, y: 60, width: frameView.frame.width, height: 60)
    monthLabelView.image = UIImage(named: "monthLabelViewImage")?.stretchableImageWithLeftCapWidth(0, topCapHeight: 0)
    monthLabel.frame = CGRect(x: (frameView.frame.width - 100) / 2, y: 75, width: 100, height: 30)
    //monthLabel.textAlignment = NSTextAlignment.Center
    monthLabel.text = CVDate(date: NSDate()).globalDescription
    monthLabel.textColor = UIColor.whiteColor()
    monthLabel.font = UIFont(name: "HYChenMeiZiJ", size: 22.0)!
    monthLabel.sizeToFit()
        
    menuView.frame = CGRect(x: 20, y: 110, width: frameView.frame.width - 40, height: 30)
    calendarView.frame = CGRect(x: 20, y: 140, width: frameView.frame.width - 40, height: 180)
    
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    
    
    //
    func loadDiaryData(){
        
        let entryFetch = NSFetchRequest(entityName: "DiaryEntry")
        do{
            let fetchedEntry = try managedContext.executeFetchRequest(entryFetch) as? [NSManagedObject]
            messages = fetchedEntry!
            
        }catch
        {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    func findDiaryOnDate(date:NSDate){
        let selectedDate = date
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        for message in messages{
            let diaryDate = message.valueForKey("date") as? NSDate
            if (calendar!.isDate(diaryDate!, inSameDayAsDate: selectedDate)){
                addMessageFromData(message)
            }
        }
    }
    
    
    func addMessageFromData(message:NSManagedObject)
    {
        let title = message.valueForKey("title") as? String
        let text =  message.valueForKey("text") as? String
        let emotion = message.valueForKey("emotion") as? String
        let date = message.valueForKey("date") as? NSDate
        let diaryMessage = ChatBubbleMessage(text: text!, title: title!, date: date!,emotion: emotion!)
        let cellData = ChatBubbleCellData(message: diaryMessage, frameWidth: self.view.frame.width)
        cellDataArray.append(cellData)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cellDataArray.count
    }
    
    
    
    // Get TableViewCell here
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        _ = cellDataArray[indexPath.row]
        let cell: UIChatBubbleTableViewCell
        
        if ifCellRegistered
        {
            let reusableCell: AnyObject = tableView.dequeueReusableCellWithIdentifier("UIChatBubbleTableViewCell", forIndexPath: indexPath)
            cell = reusableCell as! UIChatBubbleTableViewCell
        }
        else
        {
            let cellArray = NSBundle.mainBundle().loadNibNamed("UIChatBubbleTableViewCell", owner: self, options: nil)
            cell = cellArray[0] as! UIChatBubbleTableViewCell
            
            //register UIChatBubbleTableViewCell
            let nib = UINib(nibName: "UIChatBubbleTableViewCell", bundle: NSBundle.mainBundle())
            self.dailyDiaryTableView.registerNib(nib, forCellReuseIdentifier: "UIChatBubbleTableViewCell")
            ifCellRegistered = true
        }
        
        cell.frame.size.width = self.dailyDiaryTableView.frame.width
        cell.data = cellDataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return cellDataArray[indexPath.row].cellHeight
    }
    
    
    
    
    
    
    
    
    
    
    
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension CalenderViewController:  CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    // MARK: Optional methods
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        loadDiaryData()
        clearCellData()
        let date = dayView.date.convertedDate()
        findDiaryOnDate(date!)
        dailyDiaryTableView.reloadData()
        
        //print(date.getDate())

            
        //print("\(calendarView.presentedDate.commonDescription) is selected!")
        
        
    }
    
    
    func clearCellData(){
        if cellDataArray.count != 0{
            cellDataArray.removeAll()
        }
    }
    
    
    
   
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.frame = monthLabel.frame
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
  
    /*
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let day = dayView.date.day
        let randomDay = Int(arc4random_uniform(31))
        if day == randomDay {
            return true
        }
        
        return false
    }
   
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        let day = dayView.date.day
        
        let red = CGFloat(arc4random_uniform(600) / 255)
        let green = CGFloat(arc4random_uniform(600) / 255)
        let blue = CGFloat(arc4random_uniform(600) / 255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let numberOfDots = Int(arc4random_uniform(3) + 1)
        switch(numberOfDots) {
        case 2:
            return [color, color]
        case 3:
            return [color, color, color]
        default:
            return [color] // return 1 dot
        }
    }

    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }

*/

}

// MARK: - CVCalendarViewDelegate


extension CalenderViewController: CVCalendarViewDelegate {
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        /*
        let originX = dayView.frame.origin.x - 5
        let originY = dayView.frame.origin.y - 5
        let width = dayView.frame.width + 10
        let height = dayView.frame.height + 10
        let rect = CGRectMake(originX, originY, width, height)
        */
        let circleView = CVAuxiliaryView(dayView: dayView,rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
       // Message View
    
    
    //let DiarySubView = UITableViewController()
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

   /* func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour: UIColor = .blueColor()
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.CGColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
        let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.CGPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }

    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (Int(arc4random_uniform(3)) == 1) {
            return true
        }
        
        return false
    }
*/
}

    
// MARK: - CVCalendarViewAppearanceDelegate

extension CalenderViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions

extension CalenderViewController {
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on {
            calendarView.changeDaysOutShowingState(false)
            shouldShowDaysOut = true
        } else {
            calendarView.changeDaysOutShowingState(true)
            shouldShowDaysOut = false
        }
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    @IBAction func toWeekView(sender: AnyObject) {
        calendarView.changeMode(.WeekView)
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(sender: AnyObject) {
        calendarView.changeMode(.MonthView)
    }
    
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
    
}


    


// MARK: - Convenience API Demo
/*
extension CalenderViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
*/
