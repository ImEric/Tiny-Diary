//
//  DiaryViewController.swift
//  TinyCal
//
//  Created by ERIC on 9/26/15.
//  Copyright © 2015 Eric Hu. All rights reserved.
//

import UIKit
import CoreData

class DiaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var cellDataArray = [ChatBubbleCellData]()
    var messages = [NSManagedObject]()
    var ifCellRegistered = false
    var cellDetailedViewAdded = false
    var selectedIndexPath = NSIndexPath()
    
    let managedContext = DataController().managedObjectContext

    
    
    @IBOutlet var DiaryView: UIView!
    @IBOutlet weak var DiaryTableView: UITableView!
   

    @IBAction func cancelToDiaryViewController(segue:UIStoryboardSegue){
    
    }
    
    @IBAction func saveNewEntry(segue:UIStoryboardSegue){
        if let WriteNewViewController = segue.sourceViewController as? WriteNewViewController {
            
            //add the new player to the players array
            if let message:ChatBubbleMessage = WriteNewViewController.message{
                
                saveNewEntryToDataModel(message)
                let cellData = ChatBubbleCellData(message: message, frameWidth: self.DiaryTableView.frame.width)
                cellDataArray.append(cellData)
                let indexPath = NSIndexPath(forRow: cellDataArray.count - 1, inSection: 0)
                self.DiaryTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.DiaryTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
            }
        }
    }
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableView()
        //updateButtonView()
        loadDataFromDataModel()
        
        self.DiaryTableView.delegate = self
        self.DiaryTableView.dataSource = self
        
        self.DiaryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.DiaryTableView.showsVerticalScrollIndicator = false
        
      

     
        
       
   
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
         //scroll to bottom
        if cellDataArray.count != 0
        {
            let ip = NSIndexPath(forRow: cellDataArray.count - 1, inSection: 0)
            self.DiaryTableView.scrollToRowAtIndexPath(ip, atScrollPosition: UITableViewScrollPosition.None, animated: false)
        }
    }


    func updateTableView(){
        
        self.DiaryTableView.frame = CGRect(x: 40, y: 0, width: self.DiaryView.frame.width - 80, height: self.DiaryView.frame.height - 50)

    }
    

    

    

    
    /********* Core Data **********/
    
    // load data from database
    func loadDataFromDataModel(){
        let entryFetch = NSFetchRequest(entityName: "DiaryEntry")
        do{
            let fetchedEntry = try managedContext.executeFetchRequest(entryFetch) as? [NSManagedObject]
                messages = fetchedEntry!

            for var messageAdded = 0;messageAdded < messages.count;++messageAdded
            {
                addMessageFromData(messages[messageAdded])
            }
        }catch
        {
            fatalError("Failure to fetch context: \(error)")
        }
    
    }
    
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


    // save new entries to database
    func saveNewEntryToDataModel(message:ChatBubbleMessage) {
    
    
        let entity = NSEntityDescription.insertNewObjectForEntityForName("DiaryEntry", inManagedObjectContext:self.managedContext) as! DiaryEntryMO
        
        //let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        let text: String = message.text
        let date: NSDate  = message.date
        let emotion: String = message.emotion
        let title: String = message.title
        
        // add our data
        entity.setValue(text, forKey: "text")
        entity.setValue(emotion, forKey: "emotion")
        entity.setValue(date, forKey: "date")
        entity.setValue(title, forKey: "title")
        
        // save it
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

    
    
    /*********** TableView ***********/
    
    // Number of rows in TableView
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
            self.DiaryTableView.registerNib(nib, forCellReuseIdentifier: "UIChatBubbleTableViewCell")
            ifCellRegistered = true
        }
        
        cell.frame.size.width = self.DiaryTableView.frame.width
        cell.data = cellDataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    /*
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            // remove the deleted item from the model
            //let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            //let context:NSManagedObjectContext = appDel.managedObjectContext!
            //context.deleteObject(myData[indexPath.row] as NSManagedObject)
            //myData.removeAtIndex(indexPath.row)
            //context.save(nil)
            
            
            // remove the deleted item from the `UITableView`
      
        default:
            return
            
        }
    }
*/

    
    // TableViewCell's height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return cellDataArray[indexPath.row].cellHeight
    }
    
    // TableView's header
    /*
   func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.DiaryTableView.frame.width, height: 10))
        headerLabel.font = UIFont(name: "Helvetica", size: 10.0)!
        headerLabel.text = "Messages"
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.textColor = UIColor.grayColor()
        return headerLabel
    }

    */
    
    
    
    
    /************** Pop Up View **************/
    
    //detailed table view cells
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.DiaryTableView.cellForRowAtIndexPath(indexPath) as! UIChatBubbleTableViewCell
        selectedIndexPath = indexPath
    
        // declare container view and objects contained
        let detailCellView = UIScrollView()
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView

        
        let emotionImage = UIImageView()
        let title = UILabel()
        let month = UILabel()
        let date = UILabel()
        let message = UITextView()
        let divider = UIImageView()
        let deleteButton = UIButton()
        
        //set view tags
        detailCellView.tag = 200
        visualEffectView.tag = 201
        
        //customize blur view
        visualEffectView.alpha = 0
        visualEffectView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - (48 + 64))
        
        //customize container view
        detailCellView.frame = CGRect(x: 60, y: 66, width: self.DiaryTableView.frame.width, height: 0)
        detailCellView.center = visualEffectView.center
        detailCellView.backgroundColor = UIColor.whiteColor()
        detailCellView.layer.cornerRadius = 15
        
    
        
        //set animation
        UIView.animateWithDuration(0.3, animations: {
            visualEffectView.alpha = 0.5
            detailCellView.frame = CGRect(x: 40, y: 106, width: self.DiaryTableView.frame.width, height: self.DiaryTableView.frame.height - 180)
        })
    

       
        
        // set tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: "removeDetailView:")
        tapGesture.numberOfTouchesRequired = 1
        detailCellView.addGestureRecognizer(tapGesture)
        cellDetailedViewAdded = true
        
        
        //create diary message views
        emotionImage.frame = CGRect(origin: CGPoint(x:  30, y:  30
            ), size: CGSize(width: 60, height: 60))
        
        title.frame = CGRect(x: 100, y: 35, width: detailCellView.frame.width - 60 - 40, height: 30)
        message.frame = CGRect(x: 40, y: 95, width: detailCellView.frame.width - 80, height: 40)
        month.frame = CGRect(x: 100, y: 60, width: 30, height: 20)
        date.frame = CGRect(x: 150, y: 58, width: 30, height: 20)
        
        //set divider image
        
        divider.frame = CGRect(x: 40, y: 90, width: detailCellView.frame.width - 80, height: 3)
        divider.image = UIImage(named: "monthLabelViewImage")
        divider.alpha = 0.5
        
        //set deleteButton
        
        deleteButton.frame = CGRect(x: detailCellView.frame.width - 40, y: 5, width: 35, height: 35)
        deleteButton.setBackgroundImage(UIImage(named: "deleteButton"), forState: .Normal)
        deleteButton.setBackgroundImage(UIImage(named: "deleteButton"), forState: .Selected)
        deleteButton.addTarget(self, action: "deleteButtonPressed:", forControlEvents: .TouchUpInside)
        
        
            
        
        emotionImage.image = cell.emotionImageView.image
        title.text = cell.titleLabel.text
        month.text = cell.monthLabel.text
        message.text = cell.messageInDetail
        date.text = cell.dateLabel.text
        
        
        //message.numberOfLines = 0
        message.textAlignment = NSTextAlignment.Justified
        //message.lineBreakMode = NSLineBreakMode.ByWordWrapping

        
        
        title.font = cell.titleLabel.font
        message.font = UIFont(name: "FZMiaoWuS-GB", size: 18.0)!
        month.font = UIFont(name: "HYChenMeiZiJ", size: 17.0)!
        date.font = UIFont(name: "HYChenMeiZiJ", size: 17.0)!
        month.textAlignment = NSTextAlignment.Left
        date.textAlignment = NSTextAlignment.Left
        message.sizeToFit()
        message.frame = CGRect(x: message.frame.origin.x, y: message.frame.origin.y, width: message.frame.width, height: min(message.frame.height, detailCellView.frame.height - message.frame.origin.y - 30))
        month.sizeToFit()
        message.showsVerticalScrollIndicator = false
        message.showsHorizontalScrollIndicator = false
        message.editable = false
        
        
        month.textColor = UIColor.grayColor()
        date.textColor = UIColor.grayColor()
        
        
        
        
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
        detailCellView.addSubview(divider)
        detailCellView.addSubview(deleteButton)
        
        
        
        
    }
    
    
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
        blockView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - (48 + 64))
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
        self.DiaryTableView.deleteRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Fade)
        DiaryTableView.reloadData()
        //self.DiaryTableView.deleteRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Fade)
        //messages.removeAtIndex(selectedIndexPath.row/64)
    }
    
    
    
    // use this function to remove detailed cell view
    
    func removeDetailView(gesture:UIGestureRecognizer){
      for view in self.view.subviews{
        if view.tag >= 200 && view.tag <= 203{
            view.removeFromSuperview()
            cellDetailedViewAdded = false
        }
        }
    }
    
    func removeSubView(){
        for view in self.view.subviews{
            if view.tag >= 200 && view.tag <= 203{
                    view.removeFromSuperview()
                    cellDetailedViewAdded = false
                }
        }
    }

    
    
    

    

    
    
    // Use this func to add message
    func addMessage(text: String, title:String, date: NSDate, emotion:String)
    {
    
        let message = ChatBubbleMessage(text: text, title: title, date: date, emotion: emotion)
        let cellData = ChatBubbleCellData(message: message, frameWidth: self.DiaryTableView.frame.width)
        cellDataArray.append(cellData)
    }
    
    func addMessageFromData(message:NSManagedObject)
    {
        let title = message.valueForKey("title") as? String
        let text =  message.valueForKey("text") as? String
        let emotion = message.valueForKey("emotion") as? String
        let date = message.valueForKey("date") as? NSDate
        let diaryMessage = ChatBubbleMessage(text: text!, title: title!, date: date!,emotion: emotion!)
        let cellData = ChatBubbleCellData(message: diaryMessage, frameWidth: self.DiaryTableView.frame.width)
        cellDataArray.append(cellData)
        
    }
    
   
    // Add test data here
    /*
    func loadTestData()
    {
        

        addMessage("Hi!", title: "this is a test!" ,  date: NSDate(timeIntervalSinceNow: -24*60*60), emotion: "Happy")
        
        addMessage("It is really annoying to hear that my professor keep pronouncing 'factorize' as 'fuck-two-lies'.. Hope math will not fuck me like that.", title: "this is a test!" ,  date: NSDate(timeIntervalSinceNow: -24*60*60), emotion: "Angry")
        addMessage("我就是想测试一下表情。", title: "this is a test!" ,  date: NSDate(timeIntervalSinceNow: -24*60*60), emotion: "Soso")
        addMessage( "想到还有这么多功能没有实现压力好大 T T ",title: "this is a test!" , date: NSDate(timeIntervalSinceNow: -24*60*60), emotion: "Sad")
        addMessage("我就是随便复制粘贴了一下：啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊！", title: "this is a test!" , date: NSDate(timeIntervalSinceNow: -24*60*60), emotion: "Happy")


    }
*/



}


    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


