//
//  LQSlider.swift
//  LineChartDemo
//
//  Created by qingliu on 2021/4/7.
//

import UIKit

public protocol LQSliderDelegate : NSObjectProtocol{
    func thumbImageVDidSlided(slider: LQSlider)
    func sliderDidEndSlider(slider: LQSlider, centerX: CGFloat)
}

public class LQSlider: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initProps()
        createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak open var delegate:LQSliderDelegate?
    open var value: CGFloat = 0 {
        didSet{
            if value <= 0 {
                value = minimumValue;
            }
            self.sendActions(for: UIControl.Event.valueChanged)
        }
    }
    open var minimumValue: CGFloat = 0.5
    open var maximumValue: CGFloat = 7
    open var poleImageVOffX: CGFloat = 0{
        didSet{
            poleImageV?.frame.origin.x = poleImageVOffX
            poleImageV?.frame.size.width = self.frame.width - 2 * poleImageVOffX
        }
    }
    open var poleImageV: UIImageView?
    open var thumbImageV: UIImageView?
    
    private var thumbImageVWidth: CGFloat = 0
    private var animationTotalDuring: CGFloat = 0.6
    private var animationMinDuring: CGFloat = 0.2
    private var displayLink: CADisplayLink?
    
    func initProps() -> Void {
        poleImageVOffX = self.frame.width * 0.5;
        displayLink = CADisplayLink.init(target: self, selector: #selector(thumbImageVHaveSlided))
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
        displayLink?.isPaused = true
    }
    
    @objc func thumbImageVHaveSlided() -> Void{
        if (delegate !== nil) {
            delegate?.thumbImageVDidSlided(slider: self)
        }
    }
    
    func createUI() -> Void {
        poleImageV = UIImageView.init(frame: CGRect.init(x: poleImageVOffX, y:self.frame.maxY - 15, width: self.frame.width - 2 * poleImageVOffX, height: 0.5))
        poleImageV?.backgroundColor = UIColor.white
        addSubview(poleImageV!)
        
        thumbImageV = UIImageView.init(frame: CGRect.init(x: 10, y: 0, width: thumbImageVWidth, height: thumbImageVWidth))
        thumbImageV?.backgroundColor = UIColor.white
        thumbImageV?.layer.cornerRadius = thumbImageVWidth * 0.5
        addSubview(thumbImageV!)
        thumbImageV?.center.y = poleImageV!.center.y;
        
        let panGR = UIPanGestureRecognizer.init(target: self, action: #selector(panGREvent))
        thumbImageV!.addGestureRecognizer(panGR);
        let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(panGREvent))
        self.addGestureRecognizer(tapGR);
        
    }
    
    @objc func panGREvent(GR: UIPanGestureRecognizer){
        var point = GR.location(in: poleImageV)
        caculateWithPoint(point: &point);
        relayThumbImagV()
        if GR.state == UIGestureRecognizer.State.began {
            displayLink?.isPaused = false
        }else if(GR.state == UIGestureRecognizer.State.ended){
            displayLink?.isPaused = true
            didEndGestureRecognizer()
        }
    }
    
    func didEndGestureRecognizer(){
        if self.delegate !== nil {
            delegate?.sliderDidEndSlider(slider: self, centerX: thumbImageV!.center.x
            )
        }
    }
    
    @objc func tapGREvent(GR: UITapGestureRecognizer){
        var point = GR.location(in: poleImageV)
        let oldValue: CGFloat = value;
        caculateWithPoint(point: &point);
        var absDeltaValue: CGFloat = 0.0
        if value > oldValue {
            absDeltaValue = CGFloat(self.value - oldValue)
        }else{
            absDeltaValue = CGFloat(oldValue - self.value)
        }
        let timeRatio = absDeltaValue / (maximumValue - minimumValue)
        let during = animationMinDuring * timeRatio
        
        let duration = TimeInterval(during < animationMinDuring ? animationMinDuring : during)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.relayThumbImagV()
            self.displayLink?.isPaused = false
        }) { (finished: Bool) in
            self.displayLink?.isPaused = true
            self.didEndGestureRecognizer()
        }
    }
    
    func relayThumbImagV() -> Void {
        let thumbImageCenterX = caculateThumbImageVCenterXWithValue(value: value - minimumValue)
        thumbImageV!.center.x = thumbImageCenterX
    }
    
    func caculateRatioWithValue(value: CGFloat) -> CGFloat {
        var ratio: CGFloat = 0;
        if value <= 0{
            ratio = 0
        }else{
            ratio = value / (maximumValue - minimumValue)
        }
        return ratio
    }
    
    func caculateThumbImageVCenterXWithValue(value: CGFloat) -> CGFloat{
        let ratio = caculateRatioWithValue(value: value)
        let thumbImageCenterX = poleImageV!.frame.origin.x + ratio * poleImageV!.frame.width
        return thumbImageCenterX
    }
    
    func caculateWithPoint(point: inout CGPoint) {
        if point.x < 0 {
            point.x = 0
        }
        if point.x > poleImageV!.frame.width {
            point.x = poleImageV!.frame.width
        }
        if point.x <= 0 {
            value = 0
        }else{
            value = minimumValue + point.x / poleImageV!.frame.width * (maximumValue - minimumValue)
        }
    }
}
