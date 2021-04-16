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
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() -> Void {
        label = UILabel.init(frame: frame);
        label!.textColor = UIColor.red;
        label!.font = UIFont.systemFont(ofSize: 12)
        label!.numberOfLines = 2
        label!.textAlignment = .center
        addSubview(label!)
    }
    
    func relayUI() {
        DispatchQueue.main.async {
            switch(self.status){
            case .Idle:
                self.configLabelText(text: self.string)
                let originY = self.label!.frame.origin.y
                self.label!.frame.origin.y = originY + 12.0;
                break
            case .Normal:
                let originY = self.label!.frame.origin.y
                self.label!.frame.origin.y = originY + 12.0;
                UIView.animate(withDuration: self.duration) {
                    self.configLabelText(text: self.dateString)
                    let originY = self.label!.frame.origin.y
                    self.label!.frame.origin.y = originY + 12.0;
                };
                break
            case .Scale:
                UIView.animate(withDuration: self.duration) {
                    self.configLabelText(text: self.string)
                    let originY = self.label!.frame.origin.y
                    self.label!.frame.origin.y = originY + 24.0;
                };
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
