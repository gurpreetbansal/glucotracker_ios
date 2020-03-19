//
//  HistoryChartViewScreen.swift
//  GlucoGenius
//
//  Created by i mark on 16/09/16.
//  Copyright © 2016 i mark. All rights reserved.
//

import UIKit
import Charts

class HistoryChartViewScreen: UIView,ChartViewDelegate {
    
    // MARK: - Outlets & Properties
    
    @IBOutlet weak var innerViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var innerViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var topView: UIView!
    
    var dates = [Date](); var result = [Double](); var dateStr = [String](); var timeStr = [String]()
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Intial Setup of Chart View
        chartView.pinchZoomEnabled = false
        
//        chartView.fitBar
//      let numberFormat = NumberFormatter()
//      numberFormat.numberStyle = NumberFormatter.Style.none
//      chartView.leftAxis.valueFormatter = numberFormat
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/M"
        dateStr = dateDictToShow.map{dateFormatter.string(from: $0 as Date)}
        dates = dateDictToShow as [Date]
        result = resultDictToShow
        timeStr = timeDictToShow
        
        if result.count != 0 && dates.count != 0{
            if result.count <= 3 && dates.count <= 3{
//                result.append(0); result.append(0); result.append(0);result.append(0); result.append(0); result.append(0);
//                let date = Date()
//                
//                dates.append(date); dates.append(date); dates.append(date);dates.append(date); dates.append(date); dates.append(date)
//                timeStr.append(""); timeStr.append(""); timeStr.append("");timeStr.append(""); timeStr.append(""); timeStr.append("")
                self.scrollViewSetup(result,y_axis:dates)
                setChart(dates, values: result,time: timeStr )
            } else{
                self.scrollViewSetup(result,y_axis:dates)
                setChart(dates, values: result,time: timeStr )
            }
        }
    }
    
    func scrollViewSetup(_ x_axis:[Double],y_axis:[Date]){
        
        if UIScreen.main.bounds.height > 600 {
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width  + (CGFloat(x_axis.count * 1)), height:self.chartView.frame.height/2.2)
            self.innerViewWidthConst.constant =  UIScreen.main.bounds.width + (CGFloat(x_axis.count * 1))
            self.innerViewHeightConst.constant = self.chartView.frame.height/2.2
        }
        else if UIScreen.main.bounds.height > 736{
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width + (CGFloat(x_axis.count * 1)), height:self.chartView.frame.height)
            self.innerViewWidthConst.constant =  UIScreen.main.bounds.width + (CGFloat(x_axis.count * 1))
            self.innerViewHeightConst.constant = self.chartView.frame.height
        }
        else{
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width + (CGFloat(x_axis.count * 1)), height:self.chartView.frame.height/3)
            self.innerViewWidthConst.constant =  UIScreen.main.bounds.width + (CGFloat(x_axis.count * 1))
            self.innerViewHeightConst.constant = self.chartView.frame.height/3
        }
    }
    
    func setChart(_ dataPoints: [Date], values: [Double],time:[String]) {
        
        chartView.noDataText = ""
        chartView.chartDescription?.text = ""
        chartView.xAxis.labelPosition = .bottom
        var dataEntries: [BarChartDataEntry] = []
        //let abc = drand48()
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i]])
            dataEntries.append(dataEntry)
        }
        
//        for i in 0..<50 {
//            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [abc])
//            dataEntries.append(dataEntry)
//        }
        
//        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i]])
//            dataEntries.append(dataEntry)
//        }
        //
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Dates")
        chartDataSet.setColors([MConstants.chartBarBlueColor,MConstants.orangeColor,MConstants.greenColor,MConstants.yellowColor], alpha: 1)
         //chartView.barData?.groupBars(fromX: 0.15, groupSpace: 0.1, barSpace: 0.1)
        
        if timePeriodSelected == 0{
            //let chartData = BarChartData(xVals: timeStr, dataSet: chartDataSet)
            let chartData = BarChartData(dataSet: chartDataSet)
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:timeStr)
            chartView.data = chartData
            chartView.setVisibleXRangeMaximum(6)
        }
        else{
            let chartData = BarChartData(dataSet: chartDataSet)
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dateStr)
            chartView.data = chartData
             chartView.setVisibleXRangeMaximum(6)
        }
        
        //chartView.groupBars(fromX: 0.0, groupSpace: 30.0, barSpace: 10.0)
        //chartView.scaleXEnabled = false// Comment in iBHf
         //chartView.autoScaleMinMaxEnabled = true// Comment in iBHF

        chartView.rightAxis.enabled = false
        chartView.leftAxis.axisMinimum = 0
        chartView.barData?.barWidth = 0.6
        chartView.setDragOffsetX(CGFloat(50.0))
        
        // new prperties as android
        chartView.notifyDataSetChanged()
        if(time.count>=6){
            chartView.xAxis.setLabelCount(6, force: false)
        }else{
            chartView.xAxis.setLabelCount(time.count, force: false)
        }
        chartView.xAxis.labelPosition = .bottom
        chartView.pinchZoomEnabled = false
        chartView.scaleYEnabled = false
        chartView.scaleXEnabled = false
    }
}


