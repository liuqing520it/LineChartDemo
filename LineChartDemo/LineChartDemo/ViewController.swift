//
//  ViewController.swift
//  LineChartDemo
//
//  Created by qingliu on 2021/4/6.
//

import UIKit
import Charts
import SnapKit

class ViewController: UIViewController, ChartViewDelegate {
    var tableView = UITableView();
    
    lazy var lineChart = LineChartView()
    lazy var sliderView = LQSlider()
    lazy var chartDataSource:[String] = []
    var currentIndex : NSInteger = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configChartViewProps()
        createUI()
        configChartViewData()
    }
    
    func createUI() -> Void {
        view.addSubview(lineChart)
        lineChart.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(64)
            make.height.equalTo(250)
        }
        

    }
    
    func configChartViewProps() -> Void {
        lineChart.delegate = self
        lineChart.doubleTapToZoomEnabled = false
        lineChart.chartDescription?.enabled = false
        lineChart.scaleXEnabled = false
        lineChart.scaleYEnabled = false
        lineChart.dragEnabled = true
        lineChart.drawGridBackgroundEnabled = false
        
        let limitLine = ChartLimitLine.init(limit: 50, label: "标准线")
        limitLine.lineWidth = 1.0
        limitLine.lineColor = UIColor.red
        limitLine.lineDashLengths = [5,0]
        limitLine.labelPosition = .topRight
        limitLine.valueFont = .systemFont(ofSize: 12)
        limitLine.valueTextColor = .red
        limitLine.yOffset = -2
        limitLine.xOffset = -5
        
        let leftAxis = lineChart.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(limitLine)
        
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 0.0
        leftAxis.gridLineDashLengths = [5, 0]
        leftAxis.drawZeroLineEnabled = false
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.axisLineWidth = 0
        leftAxis.labelTextColor = .red
        leftAxis.labelPosition = .insideChart
        leftAxis.labelFont = .systemFont(ofSize: 12)
        leftAxis.labelCount = 5
        leftAxis.forceLabelsEnabled = true
        leftAxis.yOffset = -6
        leftAxis.xOffset = -2
        leftAxis.gridColor = .red
        leftAxis.gridLineWidth = 0.5
        
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.enabled = false
        lineChart.xAxis.axisMaximum = 8
        lineChart.xAxis.axisMinimum = 0
        lineChart.leftAxis.enabled = true
        lineChart.legend.enabled = false
        lineChart.extraTopOffset = 12
        lineChart.animate(xAxisDuration: 0.25)
        lineChart.animate(yAxisDuration: 1)
    }

    func configChartViewData() -> Void{
        var tempArray = Array<ChartDataEntry>.init()
        for item in 0...7 {
            let val = Double(arc4random_uniform(150))
            let iconImage = UIImage.init(named: item == currentIndex ? "icon_point_select":"icon_point_nm")
            tempArray.append(ChartDataEntry.init(x: Double(item), y: val, icon: iconImage))
        }
        
        var set1 = LineChartDataSet.init()
        guard let chartData = lineChart.data else {
            set1 = LineChartDataSet.init(entries: tempArray, label: nil)
            setLineChartData(set1: set1)
            return
        }
        if chartData.dataSetCount > 0 {
            set1 = (lineChart.data?.dataSets.first as! LineChartDataSet)
            set1.replaceEntries(tempArray)
            lineChart.data?.notifyDataChanged()
            lineChart.notifyDataSetChanged()
        }else{
            set1 = LineChartDataSet.init(entries: tempArray, label: nil)
            setLineChartData(set1: set1)
        }
        
    }
    
    func setLineChartData(set1: LineChartDataSet) {
        set1.drawIconsEnabled = true
        set1.lineDashLengths = [5, 0]
        set1.highlightLineDashLengths = [5, 0]
        set1.setColor(.red)
        set1.mode = .linear
        set1.drawCircleHoleEnabled = false
        set1.drawCirclesEnabled = false
        set1.circleRadius = 0
        set1.circleHoleRadius = 0
        set1.lineWidth = 1
        set1.drawValuesEnabled = false
        set1.drawFilledEnabled = false
        lineChart.data = LineChartData.init(dataSets: [set1])
    }
    
}


