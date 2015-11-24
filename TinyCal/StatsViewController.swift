//
//  StatsViewController.swift
//  TinyCal
//
//  Created by ERIC on 10/7/15.
//  Copyright © 2015 Eric Hu. All rights reserved.
//

import UIKit
import PNChartSwift
import CoreData

class StatsViewController: UIViewController,UIScrollViewDelegate {
    
    //declaring costants and variables
    let managedContext = DataController().managedObjectContext
    var messages = [NSManagedObject]()
    
    var happyEmotionCount:Float = 0
    var sadEmotionCount:Float = 0
    var angryEmotionCount:Float = 0
    var sosoEmotionCount:Float = 0
    var happyBarWidthRatio:Float = 0.0
    var sadBarWidthRatio:Float = 0.0
    var angryBarWidthRatio:Float = 0.0
    var sosoBarWidthRatio:Float = 0.0
    var dairyDailyCount:[CGFloat] = [0,0,0,0,0,0,0]
    var weeklyDate:[String] = ["","","","","","",""]
    let fontName = NSLocalizedString("FONT", comment: "font name")
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDiaryData()
        updateEmotionCount()
        updateBarWidth()
        updateWeeklyCount()
        updateEmotionStatsView()
     
       
        
    }
    
    override func viewWillAppear(animated: Bool){
        loadDiaryData()
        updateEmotionCount()
        updateBarWidth()
        updateWeeklyCount()
        updateEmotionStatsView()
        
}
    
    override func viewDidDisappear(animated: Bool) {
        for views in self.view.subviews{
            views.removeAllSubviews()
            views.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //load data from coreData
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
    
    
    //count diaries of each mood
    func updateEmotionCount(){
        happyEmotionCount = 0
        sadEmotionCount = 0
        angryEmotionCount = 0
        sosoEmotionCount = 0

        for message in messages{
            let emotion = message.valueForKey("emotion") as! String
            switch emotion
            {
                case "Happy":
                    ++happyEmotionCount
                case "Sad":
                    ++sadEmotionCount
                case "Angry":
                    ++angryEmotionCount
                case "Soso":
                    ++sosoEmotionCount
            default:break
            }
        }
        
    }
    

    func getMaxCount()->Float{
        return (max(happyEmotionCount, sadEmotionCount, angryEmotionCount, sosoEmotionCount))
    }
    
    func updateBarWidth(){
        if (getMaxCount() != 0){
            happyBarWidthRatio = Float(happyEmotionCount/getMaxCount())
            sadBarWidthRatio = Float(sadEmotionCount/getMaxCount())
            angryBarWidthRatio = Float(angryEmotionCount/getMaxCount())
            sosoBarWidthRatio = Float(sosoEmotionCount/getMaxCount())
            print(happyBarWidthRatio)
        }
    }
    
    
    func updateEmotionStatsView(){
        
        let scrollView = UIScrollView()
        let emotionChartContainerView = UIView()
        let statsDataView = UIView()
        //let diaryLineChartContainerView = UIView()
        //let statsTableView = UITableView()
        let happyButton = UIButton()
        let angryButton = UIButton()
        let sadButton = UIButton()
        let sosoButton = UIButton()
        let emotionChartLabel = UILabel()
        let StatsChartLabel = UILabel()
        
        var bars = [UIView]()
        var grayBars = [UIView]()
        for _ in 1...4{
            bars.append(UIView())
        }
        
        for _ in 1...4{
            grayBars.append(UIView())
        }

    
        
        let VIEW_HEIGHT = 1/2 * (self.view.frame.height - 120)
        let VIEW_WIDTH = self.view.frame.width
        let LEFT_MARGIN:CGFloat = 30
        let PADDING:CGFloat = 10
        let BUTTON_WIDTH = (VIEW_HEIGHT - 5 * PADDING - 25) / 4
        let BAR_HEIGHT = BUTTON_WIDTH * 0.5
        let BAR_MAX_WIDTH = VIEW_WIDTH - 3 * LEFT_MARGIN - BUTTON_WIDTH
        
     
        
  
    
        scrollView.delegate = self
        scrollView.scrollEnabled = true
        scrollView.contentSize = CGSizeMake(2 * VIEW_WIDTH, VIEW_HEIGHT)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = CGRect(x: 0, y: 65 , width: VIEW_WIDTH, height: VIEW_HEIGHT)
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.backgroundColor = UIColor.whiteColor()
        
        emotionChartContainerView.frame = CGRect(x: 0, y: 30, width: VIEW_WIDTH, height: VIEW_HEIGHT - 30)
        emotionChartContainerView.backgroundColor = UIColor.whiteColor()
        
        statsDataView.frame = CGRect(x:0, y: VIEW_HEIGHT + 75 , width: VIEW_WIDTH, height: VIEW_HEIGHT)
        

        
        //statsTableView.frame = CGRect(x: 0, y: VIEW_HEIGHT, width: VIEW_WIDTH, height: VIEW_HEIGHT)
        
        
        
        
        
        // add a shadow layer
        
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.whiteColor()
        shadowView.frame = scrollView.frame
        let layer = shadowView.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4

        
        
        // add emotion images
        happyButton.frame = CGRect(x: LEFT_MARGIN, y: PADDING , width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        angryButton.frame = CGRect(x: LEFT_MARGIN, y: PADDING * 2 + BUTTON_WIDTH, width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        sadButton.frame = CGRect(x: LEFT_MARGIN, y: PADDING * 3 + BUTTON_WIDTH * 2 , width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        sosoButton.frame = CGRect(x: LEFT_MARGIN, y: PADDING * 4 + BUTTON_WIDTH * 3 , width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        
        happyButton.setBackgroundImage(UIImage(named: "Happy"), forState: .Normal)
        angryButton.setBackgroundImage(UIImage(named: "Angry"), forState: .Normal)
        sadButton.setBackgroundImage(UIImage(named: "Sad"), forState: .Normal)
        sosoButton.setBackgroundImage(UIImage(named: "Soso"), forState: .Normal)
        
        
        
        
        //add a crown on the most favorable emotion

        switch getMaxCount(){
        case happyEmotionCount:
            happyButton.setBackgroundImage(UIImage(named: "Happy_crown-1"), forState: .Normal)
        case angryEmotionCount:
            angryButton.setBackgroundImage(UIImage(named: "Angry_crown-1"), forState: .Normal)
        case sadEmotionCount:
            sadButton.setBackgroundImage(UIImage(named: "Sad_crown-1"), forState: .Normal)
        case sosoEmotionCount:
            sosoButton.setBackgroundImage(UIImage(named: "Soso_crown-1"), forState: .Normal)
        default:
            break
        }
        
        
        
        
        
        //add bar chart
        bars[0].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10, y: happyButton.center.y - 1/2 * BAR_HEIGHT, width: 0, height: BAR_HEIGHT)
        bars[1].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10, y: angryButton.center.y - 1/2 * BAR_HEIGHT, width: 0, height: BAR_HEIGHT)
        bars[2].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10 , y: sadButton.center.y - 1/2 * BAR_HEIGHT, width: 0, height: BAR_HEIGHT)
        bars[3].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10, y: sosoButton.center.y - 1/2 * BAR_HEIGHT, width: 0, height: BAR_HEIGHT)
        

        
        grayBars[0].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10, y: happyButton.center.y - 1/2 * BAR_HEIGHT, width: BAR_MAX_WIDTH, height: BAR_HEIGHT)
        grayBars[1].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10, y: angryButton.center.y - 1/2 * BAR_HEIGHT, width: BAR_MAX_WIDTH, height: BAR_HEIGHT)
        grayBars[2].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10, y: sadButton.center.y - 1/2 * BAR_HEIGHT, width: BAR_MAX_WIDTH, height: BAR_HEIGHT)
        grayBars[3].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10, y: sosoButton.center.y - 1/2 * BAR_HEIGHT, width: BAR_MAX_WIDTH, height: BAR_HEIGHT)

        
        
        for bar in grayBars{
            bar.alpha = 1
            bar.layer.cornerRadius = 3
            bar.backgroundColor = PNLightGreyColor
            emotionChartContainerView.addSubview(bar)
        }
        
        
        for bar in bars{
            
            bar.alpha = 0
            bar.layer.cornerRadius = 3
            bar.backgroundColor = PNGreenColor
            UIView.animateWithDuration( 0.5, animations: {
                bar.alpha = 1
            })
            
            emotionChartContainerView.addSubview(bar)
        }
        
        
        
       
        
        
        
        UIView.animateWithDuration(0.5, animations: {
            
            bars[0].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10, y: happyButton.center.y - 1/2 * BAR_HEIGHT, width: CGFloat(self.happyBarWidthRatio * Float(BAR_MAX_WIDTH)), height: BAR_HEIGHT)
            bars[1].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10, y: angryButton.center.y - 1/2 * BAR_HEIGHT, width: CGFloat(self.angryBarWidthRatio * Float(BAR_MAX_WIDTH)), height: BAR_HEIGHT)
            bars[2].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10, y: sadButton.center.y - 1/2 * BAR_HEIGHT, width: CGFloat(self.sadBarWidthRatio * Float(BAR_MAX_WIDTH)), height: BAR_HEIGHT)
            bars[3].frame = CGRect(x: LEFT_MARGIN * 2 + BUTTON_WIDTH - 10, y: sosoButton.center.y - 1/2 * BAR_HEIGHT, width: CGFloat(self.sosoBarWidthRatio * Float(BAR_MAX_WIDTH)), height: BAR_HEIGHT)

        })
        
        
        emotionChartContainerView.addSubview(happyButton)
        emotionChartContainerView.addSubview(angryButton)
        emotionChartContainerView.addSubview(sadButton)
        emotionChartContainerView.addSubview(sosoButton)


        
        //emotion chart label
        emotionChartLabel.text = NSLocalizedString("STATS_EMOTION_BARCHART_HEADER", comment: "emotion chart header")
        emotionChartLabel.font = UIFont(name: fontName, size: 20)
        emotionChartLabel.sizeToFit()
        emotionChartLabel.center = CGPoint(x: self.view.center.x, y: 20)
        
    
        
        
        
        // load line chart
        
        
        let lineChart:PNLineChart = PNLineChart(frame: CGRectMake(VIEW_WIDTH + 20, 50, VIEW_WIDTH - 40, VIEW_HEIGHT - 50))
        lineChart.yLabelFormat = "%1.f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clearColor()
        lineChart.xLabels = weeklyDate
        lineChart.showCoordinateAxis = true
        //lineChart.delegate = self
        
        // Line Chart Nr.1
        var data01Array: [CGFloat] = dairyDailyCount
        let data01:PNLineChartData = PNLineChartData()
        data01.color = PNGreenColor
        data01.itemCount = data01Array.count
        data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
        
        data01.getData = ({(index: Int) -> PNLineChartDataItem in
            let yValue:CGFloat = data01Array[index]
            let item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        lineChart.chartData = [data01]
        lineChart.strokeChart()
        //diaryLineChartContainerView.addSubview(lineChart)
        
        
        //stats line chart label
        StatsChartLabel.text = NSLocalizedString("STATS_WEEKLY_LINECHART_HEADER", comment: "line chart header")
        StatsChartLabel.font = UIFont(name: fontName, size: 20)
        StatsChartLabel.sizeToFit()
        StatsChartLabel.center = CGPoint(x: lineChart.center.x, y: 20)
        
        
        // stats labels view
        
        let totalCountLabel = UILabel()
        let frequentWritingPeriodLabel = UILabel()
        let dayOfInspirationLabel = UILabel()
        let longestStreakLabel = UILabel()
        var stars = [UIImageView]()
        for _ in 0...3{
            stars.append(UIImageView())
        }
        
        for i in 0...3{
            stars[i].image = UIImage(named: "star")
            stars[i].frame = CGRect(x: happyButton.center.x - BUTTON_WIDTH/4, y: PADDING * (2.5 + CGFloat(i)) + BUTTON_WIDTH * CGFloat(i) , width: BAR_HEIGHT / 2, height: BAR_HEIGHT / 2)
            statsDataView.addSubview(stars[i])
        }
        
    
        
        let totalCount = getTotalCount()
        let frequentWritingPeriod = getFrequentWritingPeriod()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = NSLocalizedString("DATE_FORMAT", comment: "")
        let dateOfInspiration = dateFormatter.stringFromDate(getDayOfInspiration())
        let longestStreak = getLongestStreak()
        
        totalCountLabel.text = NSLocalizedString("STATS_TOTAL_COUNT_LABEL_TITLE", comment: "") + " \(totalCount)"
        frequentWritingPeriodLabel.text = NSLocalizedString("STATS_FREQUENT_WRITING_PERIOD_LABEL_TITLE", comment: "") + " \(frequentWritingPeriod):00 - \(frequentWritingPeriod+1):00"
        dayOfInspirationLabel.text = NSLocalizedString("STATS_DAY_OF_INSPIRATION_LABEL_TITLE", comment: "") + " \(dateOfInspiration)"
        longestStreakLabel.text = NSLocalizedString("STATS_LONGEST_STREAK_LABEL_TITLE", comment: "") + " \(longestStreak)"
        
        
        totalCountLabel.frame = CGRect(x: LEFT_MARGIN * 2, y: PADDING * 2, width: BAR_MAX_WIDTH, height: BAR_HEIGHT)
        frequentWritingPeriodLabel.frame = CGRect(x: LEFT_MARGIN * 2, y: PADDING * 3 + BUTTON_WIDTH, width: BAR_MAX_WIDTH, height: BAR_HEIGHT)
        dayOfInspirationLabel.frame = CGRect(x: LEFT_MARGIN * 2, y: PADDING * 4 + BUTTON_WIDTH * 2, width: BAR_MAX_WIDTH, height: BAR_HEIGHT)
        longestStreakLabel.frame = CGRect(x: LEFT_MARGIN * 2, y: PADDING * 5 + BUTTON_WIDTH * 3, width: BAR_MAX_WIDTH, height: BAR_HEIGHT)
        
        
        totalCountLabel.font = UIFont(name: fontName, size: 16)
        frequentWritingPeriodLabel.font = UIFont(name: fontName, size: 16)
        dayOfInspirationLabel.font = UIFont(name: fontName, size: 16)
        longestStreakLabel.font = UIFont(name: fontName, size: 16)
        
        
        totalCountLabel.sizeToFit()
        frequentWritingPeriodLabel.sizeToFit()
        dayOfInspirationLabel.sizeToFit()
        longestStreakLabel.sizeToFit()
        
        
        //add all subviews
        scrollView.addSubview(emotionChartLabel)
        scrollView.addSubview(StatsChartLabel)
        scrollView.addSubview(lineChart)
        scrollView.addSubview(emotionChartContainerView)
        
        statsDataView.addSubview(totalCountLabel)
        statsDataView.addSubview(frequentWritingPeriodLabel)
        statsDataView.addSubview(dayOfInspirationLabel)
        statsDataView.addSubview(longestStreakLabel)
        //scrollView.addSubview(diaryLineChartContainerView)
        //self.view.addSubview(statsTableView)
        self.view.addSubview(shadowView)
        self.view.addSubview(scrollView)
        self.view.addSubview(statsDataView)
        
        
    }
    
    func getTotalCount()->Int{
        
        return messages.count
    }
    
    
    func getFrequentWritingPeriod()->Int{
        var frequentHour = -1
        var hourArray = [Int]()
        for _ in 0...23
        {
            hourArray.append(0)
        }
      
        for message in messages
        {
            
            let date = message.valueForKey("date") as! NSDate
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH"
            let hour = Int(dateFormatter.stringFromDate(date))
            for i in 0...23{
                if (i == hour){
                ++hourArray[i]
                }
            }
            
        }
        
        for i in 0...23
        {
            if hourArray[i] == hourArray.maxElement(){
                frequentHour = i
            }
        }

        return frequentHour
    }
    

    func getDayOfInspiration()->NSDate{
        let calendar = NSCalendar.currentCalendar()
        var frequentDate = NSDate()
        var previousDate = NSDate()
        var currentCount = 1
        var maxCount = 1
        var firstMessage = true
        for message in messages{
            if (firstMessage){
                previousDate = message.valueForKey("date") as! NSDate
                frequentDate = previousDate
                firstMessage = false
                continue
            }
            
            let currentDate =  message.valueForKey("date") as! NSDate
            if (calendar.isDate(currentDate, inSameDayAsDate: previousDate))
            {
                currentCount++
                if (currentCount >= maxCount)
                {
                    maxCount = currentCount
                    frequentDate = currentDate
                }
            }else
            {
                currentCount = 1
            }
            previousDate = currentDate
        
        }
        return frequentDate
    }
    
    func getLongestStreak()->Int{
        let calendar = NSCalendar.currentCalendar()
        var previousDate = NSDate()
        var currentCount = 0
        var maxCount = 0
        var firstMessage = true
        for message in messages{
            if (firstMessage){
                previousDate = message.valueForKey("date") as! NSDate
                currentCount = 1
                maxCount = 1
                firstMessage = false
                continue
            }
            
            let currentDate =  message.valueForKey("date") as! NSDate
            let expectedDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: previousDate, options: .MatchStrictly)
            if (calendar.isDate(currentDate, inSameDayAsDate: previousDate))
            {
                continue
            }
            else if (calendar.isDate(currentDate, inSameDayAsDate: expectedDate!))
            {
                currentCount++
                if (currentCount >= maxCount)
                {
                    maxCount = currentCount
                }
            }else
            {
                currentCount = 1
            }
            
            previousDate = currentDate
            
        }
        
        return maxCount
    }

    
    
    func updateWeeklyCount(){
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        dairyDailyCount = [0,0,0,0,0,0,0]
        for i in 0...6 {
            let components = NSDateComponents()
            components.day = i - 6
            let date:NSDate = calendar.dateByAddingComponents(components, toDate: today, options: [])!
            for message in messages{
                let dataDate = message.valueForKey("date") as! NSDate
                if  calendar.isDate(dataDate, inSameDayAsDate: date){
                    ++dairyDailyCount[i]
                }
            }
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd"
            weeklyDate[i] = dateFormatter.stringFromDate(date)
            
        }
    }
    
    



}
