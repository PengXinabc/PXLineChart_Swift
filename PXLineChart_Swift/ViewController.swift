//
//  ViewController.swift
//  PXLineChart_Swift
//
//  Created by Xin Peng on 2017/6/15.
//  Copyright © 2017年 EB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pXLineChartView: PXLineChartView!
    var fill = false
    var lines: [[PointItemProtocol]]!//折线count
    var xElements: [String]!//x轴数据
    var yElements: [String]!//y轴数据
    
    func lineData(_ fill: Bool) -> [[PointItemProtocol]] {
        let firstline = [["xValue": "16-2", "yValue": "1000"],
                         ["xValue": "16-4", "yValue": "2000"],
                         ["xValue": "16-6", "yValue": "1700"],
                         ["xValue": "16-8", "yValue": "3100"],
                         ["xValue": "16-9", "yValue": "3500"],
                         ["xValue": "16-12", "yValue": "3400"],
                         ["xValue": "17-02", "yValue": "1100"],
                         ["xValue": "17-04", "yValue": "1500"]]
        
        let secondline = [["xValue": "16-2", "yValue": "2000"],
                          ["xValue": "16-3", "yValue": "2200"],
                          ["xValue": "16-4", "yValue": "3000"],
                          ["xValue": "16-6", "yValue": "3750"],
                          ["xValue": "16-7", "yValue": "3800"],
                          ["xValue": "16-8", "yValue": "4000"],
                          ["xValue": "16-10", "yValue": "2000"]]
        var firstLineItems: [PointItemProtocol] = []
        var secondLineItems: [PointItemProtocol] = []
        for i in 0..<firstline.count {
            var item = PointItem()
            let itemDic = firstline[i]
            item.price = itemDic["yValue"]!
            item.time = itemDic["xValue"]!
            item.chartLineColor = UIColor.red
            item.chartPointColor = UIColor.red
            item.pointValueColor = UIColor.red
            if fill {
                item.chartFillColor = UIColor(red: 0, green: 0.5, blue: 0.2, alpha: 0.5)
            }
            item.chartFill = fill
            firstLineItems.append(item)
        }
        
        for i in 0..<secondline.count {
            var item = PointItem()
            let itemDic = secondline[i]
            item.price = itemDic["yValue"]!
            item.time = itemDic["xValue"]!
            item.chartLineColor = UIColor(red: 0.2, green: 1, blue: 0.7, alpha: 1)
            item.chartPointColor = UIColor(red: 0.2, green: 1, blue: 0.7, alpha: 1)
            item.pointValueColor = UIColor(red: 0.2, green: 1, blue: 0.7, alpha: 1)
            if fill {
                item.chartFillColor = UIColor(red: 0.5, green: 0.1, blue: 0.8, alpha: 0.5)
            }
            item.chartFill = fill
            secondLineItems.append(item)
        }
        return [firstLineItems, secondLineItems]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lines = lineData(fill)
        pXLineChartView.delegate = self
        xElements = ["16-2","16-3","16-4","16-5","16-6","16-7","16-8","16-9","16-10","16-11","16-12","17-01","17-02","17-03","17-04","17-05"]
//        yElements = ["1000","2000","3000","4000","5000"];
        yElements = ["0","500","1000","2000","3000", "5000"];
    }
    
}

extension ViewController: PXLineChartViewDataSource {
    
    //
    func numberOfChartlines() -> Int {
        return lines.count
    }
    
    //通用设置
    func lineChartViewAxisAttributes() -> AxisAttributes {
        return (nil, Float(40), Float(40), Float(50), Float(25),
                UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 1),
                UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 1),
                UIColor(red: 244.0/255, green: 244.0/255, blue: 244.0/255, alpha: 1),
                false,
                UIFont.systemFont(ofSize: 10),
                false,
                true,
                true,
                Float(2))
    }
    
    //每条line对应的point数组
    func plotsOflineIndex(_ lineIndex: Int) -> [PointItemProtocol] {
        return lines[lineIndex]
    }
    
    //x轴y轴对应的元素count
    func numberOfElementsCountWithAxisType(_ axisType: AxisType) -> Int {
        return (axisType == .AxisTypeY) ?  yElements.count : xElements.count;
    }
    
    //x轴y轴对应的元素view
    func elementWithAxisType(_ axisType: AxisType, _ axisIndex: Int) -> UILabel {
        let label = UILabel()
        var axisValue = ""
        if axisType == .AxisTypeX {
            axisValue = xElements[axisIndex]
            label.textAlignment = .center
        }else{
            axisValue = yElements[axisIndex]
            label.textAlignment = .right
        }
        label.text = axisValue
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        return label
    }
    
    //点击point回调响应
    func elementDidClickedWithPointSuperIndex(_ superidnex: Int, _ pointSubIndex: Int) {
        guard let item = lines[superidnex][pointSubIndex] as? PointItem else {
            return
        }
        let xTitle = item.time
        let yTitle = item.price
        let alertView = UIAlertController(title: yTitle, message: "x:\(xTitle) \ny:\(yTitle)", preferredStyle: .alert)
        let  alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fill = !fill;
        lines = lineData(fill)
        pXLineChartView.reloadData()
    }
    
}


