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
    
    @IBOutlet weak var containerView: UIView!
 
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthLabelView: UIImageView!
    //@IBOutlet weak var daysOutSwitch: UISwitch!
    
    @IBOutlet var frameView: UIView!
    
    var ifCellRegistered = false
    let managedContext = DataController().managedObjectContext
    var cellDataArray = [ChatBubbleCellData]()
    var messages = [NSManagedObject]()
    var selectedIndexPath = NSIndexPath()
    var lastSelectedDate = NSDate()
    let fontName = NSLocalizedString("FONT", comment: "font name")
    // MARK: - Properties
    
    
    
    
    
    
    internal var shouldShowDaysOut = true
    internal var animationFinished = true
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableViewFrame()
        updateCalendarFrame()
        loadDiaryData()
        findDiaryOnDate(lastSelectedDate)
        self.dailyDiaryTableView.delegate = self
        self.dailyDiaryTableView.dataSource = self
        
        self.dailyDiaryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.dailyDiaryTableView.showsVerticalScrollIndicator = false
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        reloadTalbeViewCell(lastSelectedDate)
    }
    
    
    func updateTableViewFrame(){
        
        let verticleOffset = 66 +  menuView.frame.height + containerView.frame.height
        
        dailyDiaryTableView.frame = CGRect(x: 40, y: verticleOffset , width: self.view.frame.width - 80, height: self.view.frame.height - verticleOffset - 50 )
        //self.frameView.addSubview(dailyDiaryTableView)
        print(dailyDiaryTableView.frame.origin.x, dailyDiaryTableView.frame.origin.y, dailyDiaryTableView.frame.width, dailyDiaryTableView.frame.height)
        //dailyDiaryTableView.layer.zPosition = 1
        
    }

    
   func updateCalendarFrame(){
    
    containerView.frame = CGRect(x: 0, y: 100, width: frameView.frame.width - 0, height: 205)
    containerView.backgroundColor = UIColor.whiteColor()
    
    
    
    
    print(fontName)

    
    
    
    monthLabelView.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: 60)
    monthLabelView.image = UIImage(named: "monthLabelViewImage")?.stretchableImageWithLeftCapWidth(0, topCapHeight: 0)
    monthLabel.frame = CGRect(x: (frameView.frame.width - 100) / 2, y: 75, width: 100, height: 30)
    //monthLabel.textAlignment = NSTextAlignment.Center
    monthLabel.text = CVDate(date: NSDate()).globalDescription
    monthLabel.textColor = UIColor.whiteColor()
    monthLabel.font = UIFont(name: fontName, size: 22.0)!
    monthLabel.sizeToFit()
    monthLabel.center = monthLabelView.center
        
    menuView.frame = CGRect(x: 20, y: 110, width: self.view.frame.width - 40, height: 30)
    calendarView.frame = CGRect(x: 20, y: 140, width: self.view.frame.width - 40, height: 165)

   
    let layer = containerView.layer
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 5
    
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    
    
    //load data
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
        let date = dayView.date.convertedDate()
        reloadTalbeViewCell(date!)

        
        //print(date.getDate())

            
        //print("\(calendarView.presentedDate.commonDescription) is selected!")
        
        
    }
    
    func reloadTalbeViewCell(date:NSDate){
        loadDiaryData()
        clearCellData()
        findDiaryOnDate(date)
        dailyDiaryTableView.reloadData()
        lastSelectedDate = date
    }
    
    
    func clearCellData(){
        if cellDataArray.count != 0{
            cellDataArray.removeAll()
        }
    }
    
    func checkIfNoDiaryToday(){
        if cellDataArray.count == 0{
            
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
  
    
    
    /************** Pop Up View **************/
    
    //detailed table view cells
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = dailyDiaryTableView.cellForRowAtIndexPath(indexPath) as! UIChatBubbleTableViewCell
        selectedIndexPath = indexPath
        
        // declare container view and objects contained
        let detailCellView = UIScrollView()
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        
        
        let emotionImage = UIImageView()
        let title = UILabel()
        let year = UILabel()
        let month = UILabel()
        let date = UILabel()
        let message = UITextView()
        let divider = UIImageView()
        //let deleteButton = UIButton()
        
        //set view tags
        detailCellView.tag = 200
        visualEffectView.tag = 201
        
        //customize blur view
        visualEffectView.alpha = 0
        visualEffectView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - (48 + 64))
        
        //customize container view
        detailCellView.frame = CGRect(x: 60, y: 66, width: self.dailyDiaryTableView.frame.width, height: 0)
        detailCellView.center = visualEffectView.center
        detailCellView.backgroundColor = UIColor.whiteColor()
        detailCellView.layer.cornerRadius = 15
        
        
        
        //set animation
        UIView.animateWithDuration(0.3, animations: {
            visualEffectView.alpha = 0.5
            detailCellView.frame = CGRect(x: 40, y: 106, width: self.dailyDiaryTableView.frame.width, height: self.frameView.frame.height - 180 - 66)
        })
        
        
        
        
        // set tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: "removeDetailView:")
        tapGesture.numberOfTouchesRequired = 1
        detailCellView.addGestureRecognizer(tapGesture)
        //cellDetailedViewAdded = true
        
        
        //create diary message views
        emotionImage.frame = CGRect(origin: CGPoint(x:  30, y:  30
            ), size: CGSize(width: 60, height: 60))
        
        title.frame = CGRect(x: 100, y: 35, width: detailCellView.frame.width - 60 - 40, height: 30)
        message.frame = CGRect(x: 40, y: 95, width: detailCellView.frame.width - 80, height: 40)
        year.frame = CGRect(x: 167, y: 60, width: 30, height: 20)
        month.frame = CGRect(x: 100, y: 60, width: 30, height: 20)
        date.frame = CGRect(x: 150, y: 60, width: 30, height: 20)
        
        //set divider image
        
        divider.frame = CGRect(x: 40, y: 90, width: detailCellView.frame.width - 80, height: 3)
        divider.image = UIImage(named: "monthLabelViewImage")
        divider.alpha = 0.5
        
        /*
        //set deleteButton
        
        deleteButton.frame = CGRect(x: detailCellView.frame.width - 40, y: 5, width: 35, height: 35)
        deleteButton.setBackgroundImage(UIImage(named: "deleteButton"), forState: .Normal)
        deleteButton.setBackgroundImage(UIImage(named: "deleteButton"), forState: .Selected)
        deleteButton.addTarget(self, action: "deleteButtonPressed:", forControlEvents: .TouchUpInside)
        
        */
        
        
        emotionImage.image = cell.emotionImageView.image
        title.text = cell.titleLabel.text
        month.text = cell.monthLabel.text
        message.text = cell.messageInDetail
        date.text = cell.dateLabel.text
        year.text = ", \(cell.getYear())"
        
        
        //message.numberOfLines = 0
        message.textAlignment = NSTextAlignment.Justified
        //message.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        
        
        title.font = cell.titleLabel.font
        message.font = UIFont(name: fontName, size: 18.0)!
        month.font = UIFont(name: fontName, size: 17.0)!
        date.font = UIFont(name: fontName, size: 17.0)!
        year.font = UIFont(name: fontName, size: 17.0)!
        month.textAlignment = NSTextAlignment.Left
        date.textAlignment = NSTextAlignment.Left
        year.textAlignment = NSTextAlignment.Left
        message.sizeToFit()
        month.sizeToFit()
        year.sizeToFit()
        message.frame = CGRect(x: message.frame.origin.x, y: message.frame.origin.y, width: message.frame.width, height: min(message.frame.height, detailCellView.frame.height - message.frame.origin.y - 30))
        message.showsVerticalScrollIndicator = false
        message.showsHorizontalScrollIndicator = false
        message.editable = false
        
        
        month.textColor = UIColor.grayColor()
        date.textColor = UIColor.grayColor()
        year.textColor = UIColor.grayColor()
        
        
        
        //add sub view
        visualEffectView.layer.zPosition = 0
        detailCellView.layer.zPosition = 1
        self.view.addSubview(visualEffectView)
        self.view.addSubview(detailCellView)
        detailCellView.addSubview(emotionImage)
        detailCellView.addSubview(title)
        detailCellView.addSubview(message)
        detailCellView.addSubview(date)
        detailCellView.addSubview(month)
         detailCellView.addSubview(year)
        detailCellView.addSubview(divider)
        //detailCellView.addSubview(deleteButton)
        
        
        
        
    }
    
    /*
    
    func deleteButtonPressed(Sender: UIButton!){
        deleteConfirmPopup()
    }
    
    
    func deleteConfirmPopup(){
        let popUpView = UIView()
        let blockView = UIView()
        let yesButton = UIButton()
        let noButton = UIButton()
        let promptLabel = UILabel()
        
        blockView.tag = 202
        popUpView.tag = 203
        
        //block view
        blockView.frame = CGRect(x: 0, y: 64, width: self.frameView.frame.width, height: self.frameView.frame.height - (48 + 64))
        blockView.backgroundColor = UIColor.clearColor()
        
        
        //pop up view
        popUpView.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        popUpView.center = self.view.center
        popUpView.backgroundColor = UIColor.whiteColor()
        popUpView.layer.cornerRadius = 5
        
        //shadows
        let layer = popUpView.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        
        //label and buttons
        promptLabel.frame = CGRect(x: 0, y: 8, width: popUpView.frame.width, height: 30)
        promptLabel.text = "CONFIRM DELETING?"
        promptLabel.font = UIFont(name: "FZMiaoWuS-GB", size: 20.0)!
        promptLabel.textColor = UIColor.blackColor()
        promptLabel.textAlignment = NSTextAlignment.Center
        
        yesButton.setBackgroundImage(UIImage(named: "delete"), forState: .Normal)
        yesButton.frame = CGRect(x: 15, y: 36, width: 70, height: 35)
        
        noButton.setBackgroundImage(UIImage(named: "cancel"), forState: .Normal)
        noButton.frame = CGRect(x: 110, y: 36, width: 70, height: 35)
        
        yesButton.addTarget(self, action: "confirmDeleting:", forControlEvents: .TouchUpInside)
        
        noButton.addTarget(self, action: "cancelDeleting:", forControlEvents: .TouchUpInside)
        
        
        
        blockView.layer.zPosition = 2
        popUpView.layer.zPosition = 3
        popUpView.addSubview(promptLabel)
        popUpView.addSubview(yesButton)
        popUpView.addSubview(noButton)
        self.view.addSubview(blockView)
        self.view.addSubview(popUpView)
        
        
        
    }
    
    
    func cancelDeleting(sender:UIButton){
        for view in self.view.subviews{
            if view.tag == 202 || view.tag == 203{
                view.removeFromSuperview()
                //cellDetailedViewAdded = false
            }
        }
    }
    
    func confirmDeleting(sender:UIButton){
        removeSubView()
        deleteObjectFromDataMedel()
        cellDataArray.removeAtIndex(selectedIndexPath.row)
        self.dailyDiaryTableView.deleteRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Fade)
        dailyDiaryTableView.reloadData()
        //self.DiaryTableView.deleteRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Fade)
        //messages.removeAtIndex(selectedIndexPath.row/64)
    }
    
    */
    
    // use this function to remove detailed cell view
    
    func removeDetailView(gesture:UIGestureRecognizer){
        for view in self.view.subviews{
            if view.tag >= 200 && view.tag <= 203{
                view.removeFromSuperview()
                //cellDetailedViewAdded = false
            }
        }
    }
    
    func removeSubView(){
        for view in self.view.subviews{
            if view.tag >= 200 && view.tag <= 203{
                view.removeFromSuperview()
                //cellDetailedViewAdded = false
            }
        }
    }
    
    /*
    func deleteObjectFromDataMedel(){
        
        managedContext.deleteObject(messages[selectedIndexPath.row] as NSManagedObject)
        
        messages.removeAtIndex(selectedIndexPath.row)
        //var error: NSError?
        
        do{
            try managedContext.save()
        }
        catch{
            fatalError("Failure to save context: \(error)")
        }
    }

    */


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
