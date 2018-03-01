//
//  UIColor-Extensive.swift
//  星火钱包
//
//  Created by 刘峰 on 2018/1/22.
//  Copyright © 2018年 xeenho. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
   class func colorForm(hex:UInt) -> UIColor {
        return self.init(
                       red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(hex & 0x0000FF) / 255.0,
                       alpha: 1.0)
    }
}
