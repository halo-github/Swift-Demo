//
//  Object-extension.swift
//  星火钱包
//
//  Created by 刘峰 on 2018/2/8.
//  Copyright © 2018年 xeenho. All rights reserved.
//

import Foundation
import UIKit


//swift 扩展添加属性的方法
//原理：由于swift扩展不能添加存储属性，所以考虑以计算属性获取另一对象的存储属性，该对象通过动态绑定给原对象
//创建协议 包含中间对象，两个用于绑定的key
protocol LFassociateObject {
    var newInstance: AnyObject {get}
    static var key:UnsafeRawPointer { get }       //key不要用String类型
    static var midKey:UnsafeRawPointer { get }
}
//创建空类，用于生成中间对象
class NewClass: NSObject {
    required override init() {
    }
}
//协议扩展，实现中间对象，并绑定
extension LFassociateObject {
    var newInstance: AnyObject {
        guard let obj = objc_getAssociatedObject(self, Self.key) else {
            let newInstance = NewClass.init()
            objc_setAssociatedObject(self, Self.key, newInstance, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newInstance
        }
        return obj as AnyObject
    }
}
 
//类的扩展遵守协议，并给出两个key，然后把需要的属性绑定给中间对象
//extension UIView:LFassociateObject {
//    static var key = UnsafeRawPointer("UIViewEx")
//    static var midKey: UnsafeRawPointer = UnsafeRawPointer("UIViewMidKey")
//    
//    var viewName: String{
//        get {
//            guard let value = objc_getAssociatedObject(newInstance, UIView.midKey)  else {
//                return String()
//            }
//            return value as! String
//        }
//        set {
//            objc_setAssociatedObject(newInstance, UIView.midKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//}


