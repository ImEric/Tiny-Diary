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
    
    
    let managedContext = DataController().managedObjectContext
    //var cellDataArray = [ChatBubbleCellData]()
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
       
        //loadCharts()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool){
        loadDiaryData()
        updateEmotionCount()
        updateBarWidth()
        updateWeeklyCount()
        updateEmotionStatsView()
        
        //loadCharts()
        
        // Do any additional setup after loading the view.
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
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
    
    
    func updateEmotionCount(){
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
        }
    }
    
    
    func updateEmotionStatsView(){
        
        let scrollView = UIScrollView()
        let emotionChartContainerView = UIView()
        let diaryLineChartContainerView = UIView()
        let statsTableView = UITableView()
        scrollView.delegate = self
        
       


        let VIEW_HEIGHT = 1/2 * (self.view.frame.height - 120)
        let VIEW_WIDTH = self.view.frame.width
        //let BUTTON_WIDTH:CGFloat = 60
        let LEFT_MARGIN:CGFloat = 30
        let PADDING:CGFloat = 10
        let BUTTON_WIDTH = (VIEW_HEIGHT - 5 * PADDING - 25) / 4
        let BAR_HEIGHT = BUTTON_WIDTH * 0.5
        let BAR_MAX_WIDTH = VIEW_WIDTH - 3 * LEFT_MARGIN - BUTTON_WIDTH
        
        scrollView.scrollEnabled = true
        scrollView.contentSize = CGSizeMake(2 * VIEW_WIDTH, VIEW_HEIGHT)
        scrollView.showsHorizontalScrollIndicator = false
        
        let happyButton = UIButton()
        let angryButton = UIButton()
        let sadButton = UIButton()
        let sosoButton = UIButton()
        
        var bars = [UIView]()
        var grayBars = [UIView]()
        for _ in 1...4{
            bars.append(UIView())
        }

        for _ in 1...4{
            grayBars.append(UIView())
        }

   
        scrollView.frame = CGRect(x: 0, y: 65 , width: VIEW_WIDTH, height: VIEW_HEIGHT)
        scrollView.backgroundColor = UIColor.whiteColor()
      
        
        emotionChartContainerView.frame = CGRect(x: 0, y: 30, width: VIEW_WIDTH, height: VIEW_HEIGHT - 30)
        diaryLineChartContainerView.frame = CGRect(x: VIEW_WIDTH, y: 0, width: VIEW_WIDTH, height: VIEW_HEIGHT - 5)
        statsTableView.frame = CGRect(x: 0, y: VIEW_HEIGHT, width: VIEW_WIDTH, height: VIEW_HEIGHT)
        
        
        scrollView.backgroundColor = UIColor.whiteColor()
        diaryLineChartContainerView.backgroundColor = UIColor.whiteColor()
        emotionChartContainerView.backgroundColor = UIColor.whiteColor()
        
        //shadow
        /*
        let layer = scrollView.layer
        let shadowPath = UIBezierPath(rect: scrollView.bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        layer.shadowPath = shadowPath.CGPath
        */
        
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.whiteColor()
        shadowView.frame = scrollView.frame
        let layer = shadowView.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4

        
        
        happyButton.frame = CGRect(x: LEFT_MARGIN, y: PADDING , width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        angryButton.frame = CGRect(x: LEFT_MARGIN, y: PADDING * 2 + BUTTON_WIDTH, width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        sadButton.frame = CGRect(x: LEFT_MARGIN, y: PADDING * 3 + BUTTON_WIDTH * 2 , width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        sosoButton.frame = CGRect(x: LEFT_MARGIN, y: PADDING * 4 + BUTTON_WIDTH * 3 , width: BUTTON_WIDTH, height: BUTTON_WIDTH)
        
        happyButton.setBackgroundImage(UIImage(named: "Happy"), forState: .Normal)
        angryButton.setBackgroundImage(UIImage(named: "Angry"), forState: .Normal)
        sadButton.setBackgroundImage(UIImage(named: "Sad"), forState: .Normal)
        sosoButton.setBackgroundImage(UIImage(named: "Soso"), forState: .Normal)
        
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


        
        scrollView.addSubview(emotionChartContainerView)
        scrollView.addSubview(diaryLineChartContainerView)
        self.view.addSubview(statsTableView)
        self.view.addSubview(shadowView)
        self.view.addSubview(scrollView)
        
        
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
        
        //        lineChart.delegate = self
        
        scrollView.addSubview(lineChart)
        
        
        
        
        // stats line chart
        
        statsTableView.separatorStyle = .None
        
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
            dateFormatter.dateFormat = "MMM dd"
            weeklyDate[i] = dateFormatter.stringFromDate(date)
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    [barChart setYValues:@[@1,  @10, @2, @6, @3]];
    [barChart strokeChart];
    

    */
    /*
    func loadCharts(){
        
        let FRAME_HEIGHT = self.view.frame.height
        let FRAME_WIDTH = self.view.frame.width
        let TOP_OFFSET:CGFloat = 90
        let LABEL_HEIGHT:CGFloat = 30
        let PADDING:CGFloat = 30
        let CHART_WIDTH = FRAME_WIDTH - 40
        let CHART_HEIGHT = (FRAME_HEIGHT - 330) / 2
        
        //load bar chart
        let barChartLabel:UILabel = UILabel(frame: CGRectMake(0, TOP_OFFSET, CHART_WIDTH, LABEL_HEIGHT))
        barChartLabel.center.x = self.view.center.x
        barChartLabel.textColor = PNGreenColor
        barChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
        barChartLabel.textAlignment = NSTextAlignment.Center
        barChartLabel.text = "Weekly Summary"
        
        let BAR_CHART_Y:CGFloat = TOP_OFFSET + LABEL_HEIGHT + PADDING
        
        let barChart:PNBarChart = PNBarChart.init(frame: CGRectMake(20, BAR_CHART_Y , CHART_WIDTH, CHART_HEIGHT))
        barChart.backgroundColor = UIColor.clearColor()
        //            barChart.yLabelFormatter = ({(yValue: CGFloat) -> NSString in
        //                var yValueParsed:CGFloat = yValue
        //                var labelText:NSString = NSString(format:"%1.f",yValueParsed)
        //                return labelText;
        //            })
        
        
        // remove for default animation (all bars animate at once)
        barChart.animationType = .Waterfall
        
        
        barChart.labelMarginTop = 5.0
        barChart.xLabels = ["MON","TUE","WED","THUR","FRI","SAT","SUN"]
        barChart.yValues = [1,24,12,18,30,10,21]
        barChart.strokeChart()
        
        
        //barChart.delegate = self
        self.view.addSubview(barChartLabel)
        self.view.addSubview(barChart)
        
    
        // load line chart
        let LINE_CHART_LABEL_Y = BAR_CHART_Y + CHART_HEIGHT + PADDING
        let lineChartLabel:UILabel = UILabel(frame: CGRectMake(0, LINE_CHART_LABEL_Y, CHART_WIDTH, LABEL_HEIGHT))
        lineChartLabel.center.x = self.view.center.x
        
        lineChartLabel.textColor = PNGreenColor
        lineChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
        lineChartLabel.textAlignment = NSTextAlignment.Center
        lineChartLabel.text = "Monthly Summary"

        
        let lineChart:PNLineChart = PNLineChart(frame: CGRectMake(20, LINE_CHART_LABEL_Y + LABEL_HEIGHT + PADDING, CHART_WIDTH
            , CHART_HEIGHT))
        lineChart.yLabelFormat = "%1.1f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clearColor()
        lineChart.xLabels = ["SEP 1","SEP 2","SEP 3","SEP 4","SEP 5","SEP 6","SEP 7"]
        lineChart.showCoordinateAxis = true
        //lineChart.delegate = self
        
        // Line Chart Nr.1
        var data01Array: [CGFloat] = [60.1, 160.1, 126.4, 262.2, 186.2, 127.2, 176.2]
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
        
        //        lineChart.delegate = self
        
        self.view.addSubview(lineChart)
        self.view.addSubview(lineChartLabel)
        //viewController.title = "Line Chart"
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
*/

}
