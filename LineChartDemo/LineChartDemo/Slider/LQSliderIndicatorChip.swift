//
//  LQSliderIndicatorChip.swift
//  LineChartDemo
//
//  Created by qingliu on 2021/4/8.
//

import UIKit

class LQSliderIndicatorChip: UIView {
    public enum CRSliderIndicatorChipStatus : Int {
        case Idle = 1
        case Normal = 2
        case Scale = 3
    }
    
    open var dateString: String = ""
    open var string: String = ""
    open var status: CRSliderIndicatorChipStatus = CRSliderIndicatorChipStatus.Idle {
        didSet {
            if(oldValue == status){
                return
            }
            status = oldValue
            relayUI()
        }
    }
    
    private var label : UILabel?
    private var duration : TimeInterval = 0.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() -> Void {
        label = UILabel.init();
        label!.textColor = UIColor.lightText;
        label!.font = UIFont.systemFont(ofSize: 12)
        label!.numberOfLines = 2
        label!.textAlignment = .center
        addSubview(label!)
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute:{
            
        })
    }
    
    func relayUI() {
        DispatchQueue.main.async {
            switch(self.status){
            case .Idle:
                self.configLabelText(text: self.string)
                break
            case .Normal:
//                self.label?.frame.
                break
            default
                break
            }
        }
    }
    
    func configLabelText(text: String) -> Void {
        label!.text = text
        label?.sizeToFit()
        let labelWidth = label!.frame.width
        label!.frame.size.width = labelWidth + 8
        label!.textAlignment = .center
    }

}
