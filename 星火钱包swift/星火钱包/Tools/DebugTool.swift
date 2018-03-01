//
//  DebugTool.swift
//  星火钱包
//
//  Created by 刘峰 on 2018/1/22.
//  Copyright © 2018年 xeenho. All rights reserved.
//

import Foundation
func DLog<T>(of:T,file:String = #file,line:Int = #line, method:String = #function) -> Void {
    #if DEBUG
        let path = String(file)
        let fileName = path.components(separatedBy: "/").last as String!
        print("\(fileName ?? "")(\(method)-\(line)):\n\(of)")
    #endif
}
