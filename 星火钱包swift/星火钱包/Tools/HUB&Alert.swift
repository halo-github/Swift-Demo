//
//  HUB.swift
//  星火钱包
//
//  Created by 刘峰 on 2018/2/5.
//  Copyright © 2018年 xeenho. All rights reserved.
//

import Foundation
import UIKit
extension UIAlertController {
    static func Alert(VC:UIViewController,title:String,okHandle:@escaping ((UIAlertAction) ->Void)) ->Void {
        let alert:UIAlertController = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let cancle:UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let ok:UIAlertAction = UIAlertAction.init(title: "确定", style: .default, handler: okHandle)
        alert.addAction(ok)
        alert.addAction(cancle)
        VC.present(alert, animated: true, completion: nil)
    }
}
