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
    
    let managedContext = DataController().managedObjectContext

    
    @IBOutlet var DiaryView: UIView!
    @IBOutlet weak var DiaryTableView: UITableView!
    @IBOutlet weak var createNewEntryButton: UIButton!
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
                self.DiaryTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            }
        }
    }
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromDataModel()
        updateTableView()
        
        self.DiaryTableView.delegate = self
        self.DiaryTableView.dataSource = self
        
        self.DiaryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.DiaryTableView.showsVerticalScrollIndicator = false
        
     
        
        //loadTestData()
        if cellDataArray.count != 0
        {
            let ip = NSIndexPath(forRow: cellDataArray.count - 1, inSection: 0)
            self.DiaryTableView.scrollToRowAtIndexPath(ip, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        }
        
               // Do any additional setup after loading the view.
    }
    


    func updateTableView(){
        self.DiaryTableView.frame = CGRect(x: 40, y: 40, width: self.DiaryView.frame.width - 80, height: self.DiaryView.frame.height - 90)
        
        self.createNewEntryButton.frame = CGRect(x: (self.DiaryView.frame.width - 30) / 2 , y: self.DiaryView.frame.height - 90 , width: 30, height: 30)
    }
    
    func loadMessageData(){
        
        
        //let cellData = ChatBubbleCellData(message: message, frameWidth: self.DiaryTableView.frame.width)
        //cellDataArray.append(cellData)
        
    }
    

    
    /********* Core Data **********/
    
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

    func saveNewEntryToDataModel(message:ChatBubbleMessage) {
    
    
        let entity = NSEntityDescription.insertNewObjectForEntityForName("DiaryEntry", inManagedObjectContext:self.managedContext) as! DiaryEntryMO
        
        //let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        let text: String = message.text
        let date: NSDate  = message.date
        let emotion: String = message.emotion
        
        // add our data
        entity.setValue(text, forKey: "text")
        entity.setValue(emotion, forKey: "emotion")
        entity.setValue(date, forKey: "date")
        
        // save it
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

    
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
    // Use this func to add message
    func addMessage(text: String, date: NSDate, emotion:String)
    {
    
        let message = ChatBubbleMessage(text: text, date: date, emotion: emotion)
        let cellData = ChatBubbleCellData(message: message, frameWidth: self.DiaryTableView.frame.width)
        cellDataArray.append(cellData)
    }
    
    func addMessageFromData(message:NSManagedObject)
    {
        let text =  message.valueForKey("text") as? String
        let emotion = message.valueForKey("emotion") as? String
        let date = message.valueForKey("date") as? NSDate
        let diaryMessage = ChatBubbleMessage(text: text!,date: date!,emotion: emotion!)
        let cellData = ChatBubbleCellData(message: diaryMessage, frameWidth: self.DiaryTableView.frame.width)
        cellDataArray.append(cellData)
        
    }
    
   
    // Add test data here
    func loadTestData()
    {
        

        addMessage("Hi!", date: NSDate(timeIntervalSinceNow: -24*60*60), emotion: "Happy")
        
        addMessage("It is really annoying to hear that my professor keep pronouncing 'factorize' as 'fuck-two-lies'.. Hope math will not fuck me like that.", date: NSDate(timeIntervalSinceNow: -24*60*60), emotion: "Angry")
        addMessage("我就是想测试一下表情。", date: NSDate(timeIntervalSinceNow: -24*60*60), emotion: "Soso")
        addMessage("想到还有这么多功能没有实现压力好大 T T ", date: NSDate(timeIntervalSinceNow: -24*60*60), emotion: "Sad")
        addMessage("我就是随便复制粘贴了一下：啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊！", date: NSDate(timeIntervalSinceNow: -24*60*60), emotion: "Happy")


    }



}


    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


