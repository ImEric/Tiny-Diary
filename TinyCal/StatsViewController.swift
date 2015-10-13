//
//  StatsViewController.swift
//  TinyCal
//
//  Created by ERIC on 10/7/15.
//  Copyright © 2015 Eric Hu. All rights reserved.
//

import UIKit
import PNChartSwift

class StatsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCharts()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    [barChart setYValues:@[@1,  @10, @2, @6, @3]];
    [barChart strokeChart];
    

    */
    func loadCharts(){
        
        let FRAME_HEIGHT = self.view.frame.height
        let FRAME_WIDTH = self.view.frame.width
        let TOP_OFFSET:CGFloat = 90
        //let BOTTOM_OFFSET:CGFloat = 90
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

}
