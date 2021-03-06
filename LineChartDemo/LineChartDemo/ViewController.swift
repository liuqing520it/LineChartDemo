//
//  ViewController.swift
//  LineChartDemo
//
//  Created by qingliu on 2021/4/6.
//

import UIKit
import Charts
import SnapKit

class ViewController: UIViewController {
    var tableView = UITableView();
    
    lazy var lineChart = LineChartView()
    lazy var sliderView = LQSlider()
    lazy var chartDataSource:[String] = []
    var leftMarginSpace: CGFloat = 30
    
    var currentIndex : NSInteger = 0
    var chartMoveDashLine:UIView = UIView()
    
    var sliderIndicator : LQSliderIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configChartViewProps()
        createUI()
    }
    
    func createUI() -> Void {
        chartMoveDashLine = UIView.init(frame: CGRect.init(x: 0, y: 64, width: 1, height: 250))
        chartMoveDashLine.backgroundColor = .red
        view.addSubview(chartMoveDashLine)
        
        lineChart.frame = CGRect.init(x: 0, y: 64, width: view.frame.width, height: 250)
        view.addSubview(lineChart)
        configChartViewData()
        
        let strings = ["4/26\n周一","4/27\n周二","4/28\n周三","4/29\n周四","4/30\n周五","5/1\n周六","5/2\n周天"]
        sliderIndicator = LQSliderIndicator.init(frame: CGRect.init(x: leftMarginSpace, y: 330, width: view.frame.width - 60, height: 50), strings: strings)
        sliderIndicator?.chipOffX = leftMarginSpace
        sliderIndicator?.backgroundColor = .green
        sliderIndicator?.backgroundColor = .purple
        view.addSubview(sliderIndicator!)
        
        let sliderHeight = (sliderIndicator?.frame.height ?? 0) * 0.5
        sliderView = LQSlider.init(frame: CGRect.init(x: sliderIndicator!.frame.minX, y: sliderIndicator!.frame.maxY - 15, width: sliderIndicator!.frame.width, height: sliderHeight))
        sliderView.delegate = self
        sliderView.minimumValue = 0
        sliderView.maximumValue = 7
        sliderView.value = CGFloat(self.currentIndex)
        sliderView.poleImageVOffX = 20
        view.addSubview(sliderView)
        
        thumbImageVDidSlided(slider: sliderView)
        sliderIndicator!.rr = sliderView.thumbImageV!.frame.width * 0.5
        sliderIndicator!.toCircleCenterYDistance = leftMarginSpace
        
        setMoveLineCenterXFristTime(slider: sliderView)
    }
    
    func setMoveLineCenterXFristTime(slider: LQSlider) -> Void {
        var presentationLayer = slider.thumbImageV!.layer.presentation()
        if presentationLayer == nil {
            presentationLayer = slider.thumbImageV!.layer
        }
        let thumbImageVCenter = presentationLayer?.position ?? CGPoint.zero
        let centerX = thumbImageVCenter.x + leftMarginSpace
        guard let hightlight = lineChart.getHighlightByTouchPoint(CGPoint.init(x: centerX, y: 0)) else {
            return
        }
        chartMoveDashLine.center.x = hightlight.xPx + chartMoveDashLine.frame.width * 0.5
        
    }
    
    func configChartViewProps() -> Void {
        lineChart.delegate = self
        lineChart.doubleTapToZoomEnabled = false
        lineChart.chartDescription?.enabled = false
        lineChart.scaleXEnabled = false
        lineChart.scaleYEnabled = false
        lineChart.dragEnabled = true
        lineChart.drawGridBackgroundEnabled = false
        lineChart.isUserInteractionEnabled = false
        let limitLine = ChartLimitLine.init(limit: 120, label: "标准线")
        limitLine.lineWidth = 1.0
        limitLine.lineColor = .red
        limitLine.lineDashLengths = [5,0]
        limitLine.labelPosition = .topRight
        limitLine.valueFont = .systemFont(ofSize: 12)
        limitLine.valueTextColor = .red
        limitLine.yOffset = -2
        limitLine.xOffset = -5
        
        let leftAxis = lineChart.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(limitLine)
        
        leftAxis.axisMaximum = 250
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
        leftAxis.gridColor = .lightGray
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
            if item == 0 {
                continue
            }
            let val = Double(arc4random_uniform(250))
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
    
    func changeChartLinePointImage(index: NSInteger){
        guard let chartData = lineChart.data else {
            return
        }
        if chartData.dataSetCount > 0 {
            let set1 = (lineChart.data?.dataSets.first as! LineChartDataSet)
            let entries = set1.entries
            for i in 0..<entries.count {
                let entryData = entries[i]
                let iconImage = UIImage.init(named: (i == index) ? "icon_point_select" : "icon_point_nm")
                entryData.icon = iconImage
            }
            lineChart.data?.notifyDataChanged()
            lineChart.notifyDataSetChanged()
        }
    }
}

extension ViewController : ChartViewDelegate, LQSliderDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    func sliderDidEndSlider(slider: LQSlider, centerX: CGFloat) {
        guard let chipView = sliderIndicator?.getChipViewWithCircleCenterX(centerX: centerX) else {
            return
        }
        slider.thumbImageV?.center.x = chipView.center.x
        sliderIndicator?.circleCenterX = chipView.center.x
        let chipViewInArrayIndex = sliderIndicator?.chipViews.firstIndex(of: chipView)
        changeChartLinePointImage(index: chipViewInArrayIndex ?? 0)
        let equalParts = lineChart.frame.width / 9
        let centerResult = equalParts * CGFloat((chipViewInArrayIndex! + 1)) + leftMarginSpace
        let hightlight = lineChart.getHighlightByTouchPoint(CGPoint.init(x: centerResult, y: 0))
        chartMoveDashLine.center.x = hightlight!.xPx + chartMoveDashLine.frame.width * 0.5
    }
    
    func thumbImageVDidSlided(slider: LQSlider) {
        var presentationLayer = slider.thumbImageV!.layer.presentation()
        if presentationLayer == nil {
            presentationLayer = slider.thumbImageV!.layer
        }
        let thumbImageVCenter = presentationLayer?.position ?? CGPoint.zero
        sliderIndicator?.circleCenterX = thumbImageVCenter.x
        chartMoveDashLine.center.x = CGFloat(thumbImageVCenter.x + leftMarginSpace)
        getChartViewCurrentIndexByCenterX(centerX: thumbImageVCenter.x)
    }
    
    func getChartViewCurrentIndexByCenterX(centerX: CGFloat) -> Void {
        let equalParts = lineChart.frame.width / 8.0
        let indexFloat = (centerX + leftMarginSpace) / equalParts
        
        let formatter = NumberFormatter()
        formatter.positiveFormat = "0"
        let resultValue: NSString = formatter.string(from: NSNumber(value: Float( indexFloat)))! as NSString
        
        let currentIndex = Int(resultValue.floatValue)
        if fabsf(Float(currentIndex) - Float(indexFloat)) < 0.5 {
            changeChartLinePointImage(index: currentIndex - 1)
            self.currentIndex = currentIndex
        }
        
    }
    
    
}

