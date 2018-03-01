//
//  LFRefresher.swift
//  LFSwiftTools
//
//  Created by 刘峰 on 2018/1/30.
//  Copyright © 2018年 VV. All rights reserved.
//

import Foundation
import UIKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

let refreshViewHeight:CGFloat = 50
enum RefreshStatus:Int {
    case RefreshStatusNormal
    case RefreshStatusDown
    case RefreshStatusUpMore
    case RefreshStatusError
    func dosth(sth:RefreshStatus) -> Void {
        print(sth)
    }
}


protocol RefreshHeaderAndFooter {
    var header: RefreshView { get }
    var footer: RefreshView { get }
    var isAnimating: Observable<Bool> { get }
    func startHeaderRefreshAnimating()->Void
    func startFooterRefreshAnimating()->Void
    func stopRefreshAnimating()->Void

}
private var  key:UInt8 = 0
extension UIScrollView :RefreshHeaderAndFooter,LFassociateObject{
    static var key: UnsafeRawPointer = UnsafeRawPointer("refreshKey")
    
    static var midKey: UnsafeRawPointer  = UnsafeRawPointer("UIScrollviewHeader")
    static var footKey = UnsafeRawPointer("UIScrollviewFooter")
    
    func startFooterRefreshAnimating() {
        self.footer.animating.value = true
    }
    
    func startHeaderRefreshAnimating() {
        self.header.animating.value = true
    }
    
    func stopRefreshAnimating() {
        self.header.rotate?.stopAnimating()
        self.footer.rotate?.stopAnimating()
    }
    
    var header: RefreshView {
        guard let hd = objc_getAssociatedObject(newInstance, &UIScrollView.midKey) else {
            let hd = RefreshView.init(frame: CGRect.Xinit(x: self.x(), y: self.y()+NAVIBARHEIGHT, width: self.width(), height: refreshViewHeight), status: .RefreshStatusDown)
            objc_setAssociatedObject(newInstance, &UIScrollView.midKey, hd, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return hd
        }
        return hd as! RefreshView
    }
    var footer:RefreshView {
        guard let ft = objc_getAssociatedObject(newInstance, &UIScrollView.footKey) else {
            let ft = RefreshView.init(frame: CGRect.Xinit(x: self.x(), y:  self.height() + self.y() - refreshViewHeight - TABBARHEIGHT, width: self.width(), height: refreshViewHeight), status: .RefreshStatusUpMore)
            objc_setAssociatedObject(newInstance, &UIScrollView.footKey, ft, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return ft
        }
        return ft as! RefreshView
        
    }
    var isAnimating: Observable<Bool> {
        let begin = self.rx.willBeginDragging.map{
            return true
        }
        let end = self.rx.didEndDecelerating.map{
            return false
        }
        return Observable.of(begin,end).merge()
    }

   private func creatSubViews() -> Void {
        guard let superV:UIView = self.superview else { return}
        self.backgroundColor = UIColor.clear
        superV.insertSubview(self.header, belowSubview: self)
        superV.insertSubview(self.footer, belowSubview: self)
    }
    func addRefresher(downHandler:@escaping () -> Void, upHandler:@escaping ()->Void, disposeBag:DisposeBag) -> Void {
        
        self.creatSubViews()
        self.rx.willBeginDragging.subscribe(onNext:{
            let py = self.contentOffset.y
            print(py,self.contentSize.height,"willBeginDragging")
            if py == -NAVIBARHEIGHT {
                UIView.animate(withDuration: 3, delay: 0, options: .curveLinear, animations: {
                    self.contentInset = UIEdgeInsets.init(top: 80, left: 0, bottom: 0, right: 0)
                    
                }, completion: { (_) in
                    let vv = UILabel.init(frame: CGRect.Xinit(x: 0, y: -30, width: MAINWIDTH, height: 20))
                    self.addSubview(vv)
                    vv.text = "header"
                    UIView.animate(withDuration: 1, delay:2, animations: {
                        vv.removeFromSuperview()
                        self.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
                    })
                    })
            self.startHeaderRefreshAnimating()
            }
            else if py < self.contentSize.height - MAINHEIGHT + NAVIBARHEIGHT {
                self.startFooterRefreshAnimating()
            }
        })
        .disposed(by: disposeBag)
       
        self.rx.didEndDecelerating.subscribe(onNext:{ _ in
            self.stopRefreshAnimating()
        }).disposed(by: disposeBag)
        self.rx.didEndDragging.flatMapLatest{_ ->Observable<RefreshStatus> in
            let py = self.contentOffset.y
            print(py,self.contentSize.height,"didEndDragging")
            if py < 0  {
                return Observable.just(RefreshStatus.RefreshStatusDown)
            }
            else if py > self.contentSize.height - MAINHEIGHT + NAVIBARHEIGHT {
                return Observable.just(RefreshStatus.RefreshStatusUpMore)
            }
            else {
                return Observable.never()
            }
        }
            .subscribe(onNext:{ status in
                print(status)
                switch status {
                case .RefreshStatusDown:do {
                    downHandler()
                }
                case .RefreshStatusUpMore:do {
                    upHandler()
                }
                default:break
                }
            })
            .disposed(by: disposeBag)
    }
    
}

class RefreshView: UIView {
    let animating = Variable(false)
    let disp = DisposeBag()
    var rotate:RotateView?
    init(frame:CGRect, status:RefreshStatus) {
        super.init(frame: frame)
        rotate = RotateView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        self.addSubview(rotate!)
        self.animating.asObservable().bind(to: (self.rotate?.animating)!).disposed(by: disp)
        rotate?.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class RotateView: UIView {
    let grad:CAGradientLayer = CAGradientLayer()
    let disp:DisposeBag = DisposeBag()
    var animating:Variable<Bool> = Variable(false)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addLayer()
        animating.asObservable().subscribe(onNext:{ ani in
            if ani {
                self.startAnimating()
            }else {
                self.stopAnimating()
            }
        })
        .disposed(by: disp)
    }
    func addLayer() {
        
        self.layer.addSublayer(grad)
        grad.frame = self.layer.bounds
        
        grad.colors = [UIColor.blue.cgColor,UIColor.red.cgColor,UIColor.yellow.cgColor]
//        grad.locations = [0.5]
        grad.startPoint = CGPoint.init(x: 0, y: 0)
        grad.endPoint = CGPoint.init(x: 1, y: 1)
        grad.position = CGPoint.init(x: 0, y: 0)
        grad.cornerRadius = 10
        grad.masksToBounds = true
    }
    
    func startAnimating() {
        let basicAnimate = CABasicAnimation.init(keyPath: "transform.rotation.z")
        basicAnimate.toValue = Double.pi*2
        basicAnimate.duration = 1
//        basicAnimate.repeatCount = 90
        basicAnimate.fillMode = kCAFillModeForwards
        
        let basic1 = CABasicAnimation.init(keyPath: "transform.scale")
        basic1.fromValue = 0.8
        basic1.toValue = 1
        basic1.duration = 1
        basic1.fillMode = kCAFillModeForwards
//        basic1.repeatCount = 90
        
        
        let keyframeAnimate = CAKeyframeAnimation.init(keyPath: "transform.scale")
        keyframeAnimate.values = [1,0.8,1]
        keyframeAnimate.duration = 1
        keyframeAnimate.fillMode = kCAFillModeForwards
        
        let group = CAAnimationGroup.init()
        group.animations = [basicAnimate,keyframeAnimate]
        group.duration = 1
        group.repeatCount = 99
        group.fillMode = kCAFillModeForwards
        self.layer.add(group, forKey: "group")
    }
    func stopAnimating() {
        self.layer.removeAllAnimations()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

