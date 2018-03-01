//
//  NetTool.swift
//  星火钱包
//
//  Created by 刘峰 on 2017/11/28.
//  Copyright © 2017年 xeenho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

let BASEURL = "http://app.xeenho.com"

extension  NetworkReachabilityManager{
    func watching() -> Void {
        self.listener = { status in
            print(status)
            switch status {
            case .notReachable:
                UIAlertController.Alert(VC: UIViewController.currentViewController(), title: "当前网络不可用，请检查网络", okHandle: { (_) in
                    print("haha")
                })
            //            case .unknown : DLog(of: status)
            default:
                break
            }
        }
        self.startListening()
    }
    
}


protocol Request {
    var host:String { get }
    var subUrl:String { get }
    var port:Int { get }
    var para:[String:String]? {get}
    var method:HTTPMethod { get }
    var hub:Bool { get }
}

extension Request {
    var host:String {
        return BASEURL
    }
    
    var port:Int {
        return 80
    }
    
    var method:HTTPMethod {
        return HTTPMethod.post
    }
    
    var hub:Bool {
        return false
    }
    func send<T:Request>(r:T) -> Observable<[String:Any]> {
        return Observable<[String:Any]>.create({ (ob) in
            self.xPost(subUrl: r.subUrl, para: r.para!, completion: { (value) in
                ob.onNext(value)
                ob.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    func xPost(subUrl:String,para:[String:String],completion:@escaping ([String:Any])->Void) -> Void {
        Alamofire.request("\(self.host)\(subUrl)", method: self.method, parameters: para, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { (resp) in
                let value = resp.result.value as! [String:Any]
                completion(value)
        }
    }
    
}





