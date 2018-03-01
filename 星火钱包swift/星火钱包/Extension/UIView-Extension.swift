//
//  UIView-Extensive.swift
//  星火钱包
//
//  Created by 刘峰 on 2018/1/22.
//  Copyright © 2018年 xeenho. All rights reserved.
//

import Foundation
import UIKit
let SYSVERSION = Double(UIDevice.current.systemVersion)!

let MAINWIDTH:CGFloat = UIScreen.main.bounds.width
let MAINHEIGHT:CGFloat = UIScreen.main.bounds.height
var NAVIBARHEIGHT:CGFloat  {
    if UIViewController.currentNavigationViewController().navigationBar.isHidden {
        return 20
    }
    else if MAINHEIGHT == 812 {
        return 88
    }
    else {
        return 64
    }
}
var STATUSBARHEIGHT:CGFloat {
     if MAINHEIGHT == 812 {
        return 20
    } else {
        return 44
    }
}

var TABBARHEIGHT:CGFloat {
    if UIViewController.currentUITabBarController().tabBar.isHidden {
        return 0
    }
    else if MAINHEIGHT == 812 {
        return 83
    } else {
        return 49
    }
}

//let IS6 = {
//    if
//}

extension CGRect {
    static func Xinit(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat) -> CGRect {
        return self.init(x: x, y: y, width: UIView.W6(w: width), height: height)
    }
}

extension UIView {
    
   class func W6(w:CGFloat) -> CGFloat {
        if MAINWIDTH == 414 {
            return w*414/375
        } else {
            return w
        }
    }
    
    class func Y6(y:CGFloat) -> CGFloat {
        if MAINHEIGHT == 812 {
            return y+24
        } else {
            return y
        }
    }
   
    
    
    func responseChain() -> Void {
        var next = self.next
        while (next != nil) {
            print(next as Any)
            next = next?.next
        }
    }
    
    func set(x:CGFloat) -> Void {
        self.frame = CGRect.init(x: x, y: self.y(), width: self.width(), height: self.height())
    }
    func set(y:CGFloat) -> Void {
        self.frame = CGRect.init(x: self.x(), y: y, width: self.width(), height: self.height())
    }
    func set(width:CGFloat) -> Void {
        self.frame = CGRect.init(x: self.x(), y: self.y(), width: width, height: self.height())
    }
    func set(height:CGFloat) -> Void {
        self.frame = CGRect.init(x: self.x(), y: self.y(), width: self.width(), height: height)
    }
    func set(size:CGSize) -> Void {
        self.frame = CGRect.init(x: self.x(), y: self.y(), width: size.width, height: size.height)
    }
    func x() -> CGFloat {
        return self.frame.origin.x
    }
    
    func y() -> CGFloat {
        return self.frame.origin.y
    }
    func size() -> CGSize {
        return self.frame.size
    }
    func width() -> CGFloat {
        return self.size().width
    }
    func height() -> CGFloat {
        return self.size().height
    }
}
