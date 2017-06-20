//
//  PointItem.swift
//  PXLineChart_Swift
//
//  Created by Xin Peng on 2017/6/19.
//  Copyright © 2017年 EB. All rights reserved.
//

import Foundation
import UIKit

struct PointItem {
    var price: String = ""
    var time: String = ""
    var chartLineColor: UIColor = UIColor.green
    var chartPointColor: UIColor = UIColor.red
    var pointValueColor: UIColor = UIColor.gray
    var chartFillColor: UIColor = UIColor.gray
    var chartFill = true
}


extension PointItem: PointItemProtocol {
    func px_pointXvalue() -> String {
        return time
    }
    func px_pointYvalue() -> String {
        return price
    }
    func px_chartLineColor() -> UIColor { return chartLineColor }
    func px_chartPointColor() -> UIColor { return chartPointColor }
    func px_pointValueColor() -> UIColor {return chartPointColor }
    func px_pointSize() -> CGSize { return CGSize(width: 6, height: 6) }
    func px_chartFillColor() -> UIColor { return chartFillColor }
    func px_chartFill() -> Bool { return chartFill }
}
