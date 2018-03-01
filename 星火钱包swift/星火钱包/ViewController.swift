//
//  ViewController.swift
//  星火钱包
//
//  Created by 刘峰 on 2017/11/28.
//  Copyright © 2017年 xeenho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire




class ViewController: UIViewController {
    @IBOutlet weak var userFld: UITextField!
    
    @IBOutlet weak var logBtn: UIButton!
    @IBOutlet weak var pwdFld: UITextField!
    @IBOutlet weak var resultFld: UITextView!
    @IBOutlet weak var sld: UISlider!
    @IBOutlet weak var prog: UIProgressView!
    private let disposedBag = DisposeBag()
    let url:String = "http://app.xeenho.com/user/login"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sld.rx.value.asDriver().drive(prog.rx.progress).disposed(by: disposedBag)  //drive 只在主线程，不允许错误
                DLog(of:["s","sss"])
//        UIView.animate(withDuration: 5, delay: 0, options: .repeat, animations: {
//            self.logBtn.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
//            self.logBtn.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
//        }) { (_) in
//
//        }
        return
        self.userFld.text = "17388945378"
        self.pwdFld.text = "31426flsw"
//        BindTool.shareBind.bind(propertyOfView: logBtn, to: <#T##BindModel#>)
        self.xPost(subUrl: "/user/login", para: [
            "device" : "1",
            "mobile" : self.userFld.text!,
            "pwd" : self.pwdFld.text!
            ],completion: { (value) in
                print(value)
        })
        // Do any additional setup after loading the view, typically from a nib.
       self.pwdFld.isSecureTextEntry = true
         //用户名格式验证
        let userValid: Observable = self.userFld.rx.text
            .map{$0!.count > 5}
            .share(replay: 1)
         //密码格式验证
        let pwdValid: Observable = self.pwdFld.rx.text
            .map{$0!.count > 5}
            .share(replay: 1)
//        self.view.backgroundColor = UIColor.colorForm(hex: 0x0071FF)
        
//        登陆按钮状态绑定
       Observable
            .combineLatest(userValid,pwdValid) { $1&&$0 }
            .bind(to:logBtn.rx.isEnabled)                                      //绑定到登陆按钮
            .disposed(by: disposedBag)
//        Observable.of("dd","ss","00").map({ return"\($0)xh"}).fla
//        登陆按钮点击
        logBtn.rx.tap
//            .debug()
//            .throttle(3,scheduler:MainScheduler.instance)
//            //延迟
            .do(onNext: {     //点击之后，订阅之前，请求过程中禁用
                self.logBtn.isEnabled = false
                print("throttle")
                }
            )
            .flatMapLatest {  //过滤
                return self.logIn()
                }
            .subscribe({evt in
//                let signal:Dictionary = evt.element as! [String:String]
                let text = evt.element as! [String:Any]
                self.logBtn.isEnabled = true    //恢复按钮
            })
                .disposed(by: disposedBag)
        
        }
        
    func logIn() -> Observable<[String:Any]> {
       return self.send(r: self)
        return Observable.create({ (ob:AnyObserver) -> Disposable in

            let usrname = self.userFld.text
            let pwd = self.pwdFld.text
            let paras : Parameters = ["device":"1", "mobile":usrname,"pwd":pwd] as! [String:String]
            Alamofire
                .request(self.url, method: .post, parameters: paras, encoding: URLEncoding.default, headers: nil)
                .validate()
                .responseJSON(completionHandler: { (response) in
                    let value = response.result.value as? [String:Any]
    
                    ob.onNext(value as! [String : Any])
                        ob.onCompleted()
            })
            
//                    })
            return Disposables.create()
        })
 
                    }
        
        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
private extension UIButton {
    var rx_enable : AnyObserver<Bool> {
        return Binder.init(self, scheduler: MainScheduler.instance, binding: { (btn, enable) in
            btn.isEnabled = enable
        })
        .asObserver()
    }
    
}

protocol BindModel {
    func aiya() -> Void
}

extension BindModel {
    func test() {
        print("just test")
    }
}
extension String:BindModel {
    func aiya() {
        print("ss")
    }
}

protocol BindView {
    func bind(property:String) -> Void 
}

class BindTool:NSObject {
    var model:BindModel?
    var view:UIView?
    static let shareBind = BindTool()
    func bind<T:BindModel>(propertyOfView:T, to:BindModel) {
//        to.map{
//            print($0)
//            $0.test()}
//
    }
    
}

struct neww<T> {
    var iterms = [T]()
    mutating func push(item:T) {
        iterms.append(item)
    }
   mutating func pop() -> T{
       return iterms.removeLast()
    }
    
}


extension ViewController:Request {
    var subUrl: String {
        return "/user/login"
    }
    
    var para: [String : String]? {
        return [
            "device" : "1",
            "mobile" : self.userFld.text!,
            "pwd" : self.pwdFld.text!
        ]
    }
    
    
}
