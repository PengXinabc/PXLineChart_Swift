//
//  PXLineChartView.swift
//  PXLineChart_Swift
//
//  Created by Xin Peng on 2017/6/15.
//  Copyright © 2017年 EB. All rights reserved.
//

import UIKit

typealias AxisAttributes = (yElementsCount: Int?, yElementInterval: Float?, xElementInterval: Float?, yMargin: Float?, xMargin: Float?, yAxisColor: UIColor?, xAxisColor: UIColor?, gridColor: UIColor?, gridHide: Bool?, pointFont: UIFont?, pointHide: Bool?, firstYAsOrigin: Bool?, scrollAnimation: Bool?, scrollAnimationDuration: Float?)

enum AxisType {
    case AxisTypeX, AxisTypeY
}

protocol PointItemProtocol {
    
    func px_pointYvalue() -> String //y坐标值
    func px_pointXvalue() -> String //x坐标值
    func px_chartLineColor() -> UIColor //折线color
    func px_chartPointColor() -> UIColor //point color
    func px_pointValueColor() -> UIColor //
    func px_pointSize() -> CGSize //point size
    func px_chartFillColor() -> UIColor //fill color - UIColor
    func px_chartFill() -> Bool //是否fill
    
    
}

extension PointItemProtocol {
    func px_chartLineColor() -> UIColor { return UIColor.gray }
    func px_chartPointColor() -> UIColor { return UIColor.gray }
    func px_pointValueColor() -> UIColor {return UIColor.gray }
    func px_pointSize() -> CGSize { return CGSize(width: 6, height: 6) }
    func px_chartFillColor() -> UIColor { return UIColor.green }
    func px_chartFill() -> Bool { return true }
}

protocol PXLineChartViewDataSource{
    /**折线个数*/
    func numberOfChartlines() -> Int
    
    /**每条折线对应的points
     
     @param lineIndex index of lines
     
     @return 每条折线对应的数据点，元素必须实现PointItemProtocol协议
     
     */
    func plotsOflineIndex(_ lineIndex: Int) -> [PointItemProtocol]
    
    /**x轴y轴对应的元素个数
     
     @param axisType x\y type
     
     @return x/y轴对应的元素个数
     
     */
    func numberOfElementsCountWithAxisType(_ axisType: AxisType) -> Int
    
    /**x轴y轴对应的元素视图
     
     @param axisType  (AxisTypeY-y轴 AxisTypeX-x轴)
     
     @param axisIndex -轴坐标对应的索引
     
     @return x轴y轴对应的元素视图
     
     */
    func elementWithAxisType(_ axisType: AxisType, _ axisIndex: Int) -> UILabel
    
    
    /** 坐标轴可选配置参数，目前可选配置key如下：
     
     1、yElementsCount; //y轴坐标个数
     
     2、yElementInterval; //y轴坐标间隔
     
     3、xElementInterval; //x轴坐标间隔
     
     4、yMargin; //y轴距superview边距
     
     5、xMargin; //x轴距superview边距
     
     6、yAxisColor; //y轴color - UIColor
     
     7、xAxisColor; //x轴color - UIColor
     
     8、gridColor; //纹理color - UIColor
     
     9、gridHide; //显示纹理 - NSNumber（@1-不显示; @0-显示）
     
     10、pointFont; //point font - UIFont
     
     11、pointHide; // 显示point - NSNumber（@1-不显示; @0-显示）
     
     @return 坐标轴配置参数AxisAttributes
     
     @see PXLineChartConst.h
     */
    func lineChartViewAxisAttributes() -> AxisAttributes
    
    
    /**点击触发响应回调
     
     @param superidnex  -line index of points
     
     @param subindex - point index of points
     
     */
    func elementDidClickedWithPointSuperIndex(_ superidnex: Int, _ pointSubIndex: Int)
}

extension PXLineChartViewDataSource {
    func lineChartViewAxisAttributes() -> [String: Any] {
        return [:]
    }
    func elementDidClickedWithPointSuperIndex(_ superidnex: Int, _ pointSubIndex: Int) {}
}
class PXLineChartView: UIView {
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var xAxisView: PXXview!
    fileprivate var yAxisView: PXYview!
    fileprivate var chartBackgroundView: PXChartBackgroundView!
    fileprivate var yWidth: Float = 50
    fileprivate var xHeight: Float = 30
    fileprivate var xInterval: Float = 50
    fileprivate var xElements = 0
    fileprivate var axisAttributes: AxisAttributes?
    var delegate: PXLineChartViewDataSource? {
        didSet{
            xAxisView.delegate = delegate
            yAxisView.delegate = delegate
            chartBackgroundView.delegate = delegate
            yAxisView.axisAttributes = delegate?.lineChartViewAxisAttributes()
            xAxisView.axisAttributes = delegate?.lineChartViewAxisAttributes()
            chartBackgroundView.axisAttributes = delegate?.lineChartViewAxisAttributes()
            axisAttributes = delegate?.lineChartViewAxisAttributes()
        }
    }
    
    func setupView() {
        xAxisView = PXXview();
        yAxisView = PXYview();
        chartBackgroundView = PXChartBackgroundView(xAxisView, yAxisView);
        scrollView = UIScrollView();
        scrollView.bounces = false;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        xAxisView.translatesAutoresizingMaskIntoConstraints = false;
        yAxisView.translatesAutoresizingMaskIntoConstraints = false;
        chartBackgroundView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(yAxisView)
        addSubview(scrollView)
        scrollView.addSubview(xAxisView)
        scrollView.addSubview(chartBackgroundView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupInitialConstraints()
    }
    
    func setupInitialConstraints() {
        clearSubConstraints(self)
        let viewsDict: [String : Any] = ["scrollView": scrollView, "xAxisView": xAxisView, "yAxisView": yAxisView, "chartBackgroundView": chartBackgroundView]
        if let customYwidth = axisAttributes?.yMargin {
            yWidth = customYwidth
        }
        if let customXheight = axisAttributes?.xMargin {
            xHeight = customXheight
        }
        if let customXInterval = axisAttributes?.xElementInterval {
            xInterval = customXInterval
        }
        xElements = delegate?.numberOfElementsCountWithAxisType(.AxisTypeX) ?? 0
        let scrollHeight = self.frame.height
        let scrollWidth = self.frame.width - CGFloat(yWidth)
        let yHeight = self.frame.height - CGFloat(xHeight)
        var xWidth = self.frame.width - CGFloat(yWidth)
        if (xWidth < CGFloat(Float((xElements+1))*xInterval)) {
            xWidth = CGFloat(Float((xElements+1))*xInterval)
        }
        scrollView.contentSize = CGSize(width: xWidth, height: scrollHeight)
        let metrics: [String : Any] = ["yWidth": yWidth,
                                       "xWidth": xWidth,
                                       "xHeight": xHeight,
                                       "yHeight": yHeight,
                                       "scrollHeight": scrollHeight,
                                       "scrollWidth": scrollWidth]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[yAxisView(==yWidth)][scrollView]|", options: [], metrics: metrics, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView(==scrollHeight)]", options: [], metrics: metrics, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[yAxisView(==yHeight)]|", options: [], metrics: metrics, views: viewsDict))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[xAxisView(==xWidth)]|", options: [], metrics: metrics, views: viewsDict))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[chartBackgroundView(==xWidth)]", options: [], metrics: metrics, views: viewsDict))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[chartBackgroundView(==yHeight)][xAxisView(==xHeight)]|", options: [], metrics: metrics, views: viewsDict))
        
        scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width-scrollView.frame.width, y: 0), animated: true)
        scrollAnimationIfcanScroll()
    }
    
    func clearSubConstraints(_ targetView: UIView?) {
        guard let targetView = targetView else {
            return
        }
        if targetView != self {
            NSLayoutConstraint.deactivate(targetView.constraints)
        }
        for subview in targetView.subviews {
            clearSubConstraints(subview)
        }
        
    }
    
    func reloadData() {
        setNeedsLayout()
        layoutIfNeeded()
        xAxisView.refresh()
        yAxisView.refresh()
        chartBackgroundView.refresh()
    }
    
    func scrollAnimationIfcanScroll() {
        layer.removeAllAnimations()
        scrollView.layer.removeAllAnimations()
        let duration = axisAttributes?.scrollAnimationDuration ?? 0.5
        if let canAnimate = axisAttributes?.scrollAnimation, canAnimate, scrollView.contentSize.width > scrollView.frame.width {
            UIView.animate(withDuration: Double(duration), delay: 0, options: .curveEaseInOut, animations: {
                self.scrollView.setContentOffset(CGPoint(), animated: true)
            }, completion: nil)
        }
    }
    
}





