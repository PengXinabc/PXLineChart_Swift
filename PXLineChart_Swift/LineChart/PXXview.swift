//
//  PXXview.swift
//  PXLineChart_Swift
//
//  Created by Xin Peng on 2017/6/15.
//  Copyright © 2017年 EB. All rights reserved.
//

import UIKit

class PXXview: UIView {
    
    fileprivate var xlineView: UIView = UIView()
    fileprivate var xElements: [String] = []
    fileprivate var xElementInterval: Float = 40
    var delegate: PXLineChartViewDataSource?
    var axisAttributes: AxisAttributes? {
        didSet {
            if let xElementInterval = axisAttributes?.xElementInterval {
                self.xElementInterval = xElementInterval
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadXaxis()
    }
    
    func reloadXaxis() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        xElements.removeAll()
        if let lineColor = axisAttributes?.xAxisColor {
            xlineView.backgroundColor = lineColor
        }else{
            xlineView.backgroundColor = UIColor.gray
        }
        xlineView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
        addSubview(xlineView)
        guard let elementCons = delegate?.numberOfElementsCountWithAxisType(.AxisTypeX) else {
            return
        }
        if let xElementInterval = axisAttributes?.xElementInterval {
            self.xElementInterval = xElementInterval
        }
        for index in 0..<elementCons {
            if let elementView = delegate?.elementWithAxisType(.AxisTypeX, index) {
                let attr = [NSAttributedStringKey.font: elementView.font!]
                var elementSize = CGSize()
                if let elementViewText = elementView.text {
                    xElements.append(elementViewText)
                    elementSize = (elementViewText as NSString).size(withAttributes: attr)
                }
                elementView.frame = CGRect(x: 0, y: self.frame.height-elementSize.height, width: elementSize.width, height: elementSize.height)
                elementView.center = CGPoint(x: CGFloat(xElementInterval*Float(index+1)), y: elementView.center.y)
                addSubview(elementView)
            }
        }
    }
    
    /**坐标转换
     
     @param xAxisValue x坐标对应的文本text
     
     @return x轴坐标位置
     */
    func pointOfXcoordinate(_ xAxisValue: String) -> CGFloat{
        if xAxisValue.isEmpty {
            return 0
        }
        guard let xindex = xElements.index(of: xAxisValue) else {
            return 0
        }
        return CGFloat(Float((xindex+1))*xElementInterval)
    }
    
    func refresh() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}
