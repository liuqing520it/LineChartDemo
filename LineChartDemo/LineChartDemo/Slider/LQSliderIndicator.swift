//
//  LQSliderIndicator.swift
//  LineChartDemo
//
//  Created by qingliu on 2021/4/8.
//

import UIKit

class LQSliderIndicator: UIView {
    open var circleCenterX : CGFloat = 0.0{
        didSet{
            circleCenter.x = circleCenterX
            relayUI()
        }
    }
    open var rr : CGFloat = 11
    open var toCircleCenterYDistance : CGFloat = 0.0
    open var chipOffX : CGFloat = 0.0{
        didSet{
            if chipViews.count > 0 {
                let offX: CGFloat = 15
                ///布局子视图
                for index in 0..<chipViews.count {
                    let chipView = chipViews[index]
                    chipView.frame = CGRect.init(x: offX + chipView.frame.width * CGFloat(index), y: 0, width: chipView.frame.width, height: chipView.frame.height)
                }
                
            }
        }
    }
    open var chipViews : [LQSliderIndicatorChip] = [];
    
    private var path: UIBezierPath?
    private var maskLayer: CAShapeLayer?
    private var bgLayer: CAShapeLayer?
    private var gradientLayer: CAGradientLayer?
    private var circleCenter: CGPoint = CGPoint.init()
    private var y0: CGFloat = 0.0
    private var lastNearestChipView : LQSliderIndicatorChip?
    private var strings: [String] = []

    convenience init(frame: CGRect, strings:[String]) {
        self.init(frame: frame)
        self.strings = strings;
        initParams()
        createUI()
    }
    
    func initParams() -> Void {
        circleCenter = CGPoint.init(x: circleCenterX, y: self.frame.size.height + toCircleCenterYDistance)
        y0 = circleCenter.y - toCircleCenterYDistance
        generateChips()
    }
    
    func generateChips() -> Void {
        chipViews = [];
        if strings.count == 0 {
            return
        }
        let stringWidth : CGFloat = (frame.width - 30) / CGFloat(strings.count)
        for i in 0..<strings.count {
            let tempStr = strings[i]
            let chipView : LQSliderIndicatorChip = LQSliderIndicatorChip.init(frame: CGRect.init(x: 0, y: 0, width: stringWidth, height: self.frame.size.height))
            if tempStr.contains("\n") {
                chipView.dateString = tempStr
                chipView.string = tempStr.components(separatedBy: "\n").last ?? ""
            }else{
                chipView.dateString = tempStr
                chipView.string = tempStr
            }
            addSubview(chipView)
            chipViews.append(chipView)
        }
    }
    
    func createUI(){
        path = generatePath()
        bgLayer = CAShapeLayer.init()
        bgLayer!.frame = self.bounds;
        bgLayer!.backgroundColor = UIColor.lightText.cgColor
        layer.insertSublayer(bgLayer!, at: 0)
        
        maskLayer = CAShapeLayer.init()
        maskLayer?.frame = self.bounds
        maskLayer?.path = path?.cgPath
        maskLayer?.fillColor = UIColor.white.cgColor
        maskLayer?.masksToBounds = true
        layer.insertSublayer(maskLayer!, at: 1)
        
    }
    
    func generatePath() -> UIBezierPath {
        let leftUp = CGPoint.init(x: 0, y: 0)
        
        let leftDown = CGPoint.init(x: 0, y: self.frame.height)
        let rightDown = CGPoint.init(x: self.frame.width, y: self.frame.height)
        let rightUp = CGPoint.init(x: self.frame.width, y: 0)
        let ratioX = rr / 20
        let ratioY = 1.0
        
        let path = UIBezierPath.init()
        path.move(to: leftDown)
        
        let p1 = CGPoint.init(x: circleCenter.x - 48.0 * ratioX, y: self.frame.height)
        let p2 = CGPoint.init(x: circleCenter.x - 33.0 * ratioX, y: y0 - CGFloat(5.0 * ratioY))
        
        let p2CL = CGPoint.init(x: circleCenter.x - 40.0 * ratioX, y: y0)
        let p2CR = CGPoint.init(x: circleCenter.x - 25.0 * ratioX, y: y0 - CGFloat(10.0 * ratioY))
        
        let p3 = CGPoint.init(x: circleCenter.x, y: y0 - CGFloat(18.0 * ratioY))
        let p3CL = CGPoint.init(x: circleCenter.x - 14.0 * ratioX, y: y0 - CGFloat(18.0 * ratioY))
        
        let p3CR = CGPoint.init(x: circleCenter.x + 14.0 * ratioX, y: y0 - CGFloat(18 * ratioY))
        
        let p4 = CGPoint.init(x: circleCenter.x + 25.0 * ratioX, y: y0 - CGFloat(10.0 * ratioY))
        let p4CL = CGPoint.init(x: circleCenter.x + 25.0 * ratioX, y: y0 - CGFloat(10.0 * ratioY))
        
        let p4CR = CGPoint.init(x: circleCenter.x + 40.0 * ratioX, y: y0)
        let p5 = CGPoint.init(x: circleCenter.x + 48.0 * ratioX, y: self.frame.height)
        
        path.addLine(to: p1)
        path.addCurve(to: p2, controlPoint1: p1, controlPoint2: p2CL)
        path.addCurve(to: p3, controlPoint1: p2CR, controlPoint2: p3CL)
        path.addCurve(to: p4, controlPoint1: p3CR, controlPoint2: p4CL)
        path.addCurve(to: p5, controlPoint1: p4CR, controlPoint2: p5)
        
        path.lineJoinStyle = .round
        path.addLine(to: rightDown)
        path.addLine(to: rightUp)
        path.addLine(to: leftUp)
        path.close()
        
        return path
    }
    
    func clean(){
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    func relayUI() -> Void {
        path = generatePath()
        maskLayer?.path = path?.cgPath
        findNearstChipViewAndScale()
    }
    
    func findNearstChipViewAndScale() -> Void {
        let nearestChipView = getChipViewWithCircleCenterX(centerX: circleCenter.x)
        if (lastNearestChipView != nil) && lastNearestChipView == nearestChipView {
            
        }else{
            for chipView in chipViews {
                if chipView == nearestChipView {
                    chipView.status = .Scale
                }else{
                    chipView.status = .Normal
                }
            }
            lastNearestChipView = nearestChipView
        }
    }
    
    public func getChipViewWithCircleCenterX(centerX: CGFloat) -> LQSliderIndicatorChip?{
        var minValue : CGFloat = 0;
        var nearestChipView :LQSliderIndicatorChip? = nil
        for chipView in chipViews {
            let resultValue: CGFloat = absValue(value1: chipView.center.x, value2: centerX)
            if minValue == 0 {
                minValue = resultValue
            }
            if nearestChipView != nil {
                nearestChipView = chipView
            }
            if resultValue < minValue {
                minValue = resultValue
                nearestChipView = chipView
            }
        }
        return nearestChipView
    }
  
    func absValue(value1: CGFloat, value2: CGFloat) -> CGFloat {
        var resultValue :CGFloat = 0.0
        if value1 > value2 {
            resultValue = value1 - value2
        }else{
            resultValue = value2 - value1
        }
        return resultValue
    }
}
