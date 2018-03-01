//
//  LFError.swift
//  星火钱包
//
//  Created by 刘峰 on 2018/1/18.
//  Copyright © 2018年 xeenho. All rights reserved.
//

import Foundation
enum LFError {
    case RequestFaild
    case otherError
    case alertError(title:String, message:String, alert:Bool)
    
    func show() -> Void {
        switch self {
        case .RequestFaild:
            print("RequestFaild")
        case .alertError(let title,let msg, let alert) : do {
            print(title,msg,alert)
            }
        default: break
        }
    }
}


