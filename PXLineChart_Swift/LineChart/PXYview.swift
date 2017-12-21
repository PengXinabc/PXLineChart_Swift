//
//  PXYview.swift
//  PXLineChart_Swift
//
//  Created by Xin Peng on 2017/6/15.
//  Copyright © 2017年 EB. All rights reserved.
//

import UIKit

class PXYview: UIView {
    
    fileprivate var  ylineView: UIView = UIView()
    var delegate: PXLineChartViewDataSource?
    var axisAttributes: AxisAttributes? {
        didSet {
            if let yElementInterval = axisAttributes?.yElementInterval {
                 self.yElementInterval = yElementInterval
            }
        }
    }
    var yElementInterval: Float = 40
    fileprivate var perPixelOfYvalue: Float = -1 //坐标值/y值
    fileprivate var firstYvalue: String = "0"
    fileprivate var lastYvalue: String = "0"
    fileprivate var minSpaceValue: NSNumber?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadYaxis()
    }
    
    func reloadYaxis() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        perPixelOfYvalue = -1;
        ylineView.frame = CGRect(x: self.frame.width-1, y: 0, width: 1, height: self.frame.height)
        addSubview(ylineView)
        if let lineColor = axisAttributes?.yAxisColor {
            ylineView.backgroundColor = lineColor
        }else{
            ylineView.backgroundColor = UIColor.gray
        }
        guard let elementCons = delegate?.numberOfElementsCountWithAxisType(.AxisTypeY) else {
            return
        }
        var ytexts: [String] = [];
        for index in 0..<elementCons {
            if let elementView = delegate?.elementWithAxisType(.AxisTypeY, index) {
                if let yvalue = elementView.text {
                    ytexts.append(yvalue)
                }
            }
        }
        var ytextsCopy = ytexts
        let ySpacevales: NSMutableArray = NSMutableArray()
        if ytextsCopy.count > 2 {
            for index in 0..<(ytextsCopy.count - 1) {
                let yValue = ytexts[index+1]
                let yCopyValue = ytextsCopy[index]
                ySpacevales.add(NSNumber(integerLiteral: (Int(yValue)!-Int(yCopyValue)!)))
            }
            minSpaceValue = ySpacevales.value(forKeyPath: "@min.self") as? NSNumber
        }
        var lastElementView: UIView!
        for index in 0..<elementCons {
            if let elementView = delegate?.elementWithAxisType(.AxisTypeY, index) {
                let attr = [NSFontAttributeName: elementView.font!]
                let elementSize = ("y" as NSString).size(attributes: attr)
                var isfirstYAsOrigin = false
                if let wrapedfirstYAsOrigin = axisAttributes?.firstYAsOrigin {
                    isfirstYAsOrigin = wrapedfirstYAsOrigin
                }
                if isfirstYAsOrigin, index == 0 {
                    firstYvalue = elementView.text ?? "0"
                }
                var spaceIndex: Float = Float(exactly: index)!
                if let minspaceValue = minSpaceValue {
                    spaceIndex = (Float(elementView.text!)! - Float(firstYvalue)!) / Float(truncating: minspaceValue)
                }
                if(index == elementCons - 1) {
                    lastYvalue = elementView.text ?? ""
                }
                let y = CGFloat(yElementInterval*Float(exactly: spaceIndex)!)
                elementView.frame = CGRect(x: 0, y: self.frame.height-((elementSize.height/2)+y), width: self.frame.width-5, height: elementSize.height)
                addSubview(elementView)
                lastElementView = elementView
            }
            
        }
        
        ylineView.frame = CGRect(x: self.frame.width-1, y: lastElementView.frame.origin.y, width: 1, height: self.frame.height - lastElementView.frame.origin.y)
        
        if !firstYvalue.isEmpty && !lastYvalue.isEmpty {
            if let firstYNumvalue = Float(firstYvalue) , let lastYNumvalue = Float(lastYvalue), firstYNumvalue >= 0, lastYNumvalue > firstYNumvalue {
                perPixelOfYvalue = (yElementInterval*((lastYNumvalue-firstYNumvalue)/Float(truncating: minSpaceValue!)))/(lastYNumvalue-firstYNumvalue)
            }
        }
        
    }
    /**坐标转换
     
     @param yAxisValue y坐标对应的文本text
     
     @return y轴坐标位置
     */
    func pointOfYcoordinate(_ yAxisValue: String) -> CGFloat{
        if yAxisValue.isEmpty {
            return 0
        }
        guard let yAxisNumValue = Float(yAxisValue), let firstNumYvalue = Float(firstYvalue)  else {
            return 0
        }
        return self.frame.height - CGFloat((yAxisNumValue-firstNumYvalue)*perPixelOfYvalue)
    }
    
    func guidHeight(_ yAxisValue: String?, laterYxisValue: String?) -> Float {
        guard let yv = yAxisValue, let ylater = laterYxisValue  else {
            print("坐标值不存在")
            return 0
        }
        return (Float(ylater)! - Float(yv)!) * perPixelOfYvalue
    }
    func refresh() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}


