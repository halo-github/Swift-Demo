//
//  Rxtab.swift
//  星火钱包
//
//  Created by 刘峰 on 2018/2/2.
//  Copyright © 2018年 xeenho. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

struct TestModel {
    var name:String?
    var age:String?
//    仅提供数据格式，不参与UI控制
}

class TestViewModel {
    let input = Variable([Int]())
    let output:Observable<[TestModel]>
    init() {    //初始化处理从输入到输出的逻辑
        output = input.asObservable().map{
            $0.map{
                TestModel.init(name: "haha", age: String($0))
            }
        }
    }
}


class RxtabVC: UIViewController {
    let disp = DisposeBag()
    lazy var tab:UITableView = {
        return UITableView.init(frame: self.view.bounds, style: .plain)
        }()
    var viewModel:TestViewModel = TestViewModel()
    let  dataVar = Variable([Int]())
    
  
    func reData() -> [Int] {
        var data = [Int]()
        for _  in 0...10 {
            data.append(Int(arc4random_uniform(1000)))
        }
        return data
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
//初始化tableview
        self.tab.register(TestCell.self, forCellReuseIdentifier: "cell")
        self.tab.rowHeight = 88
        self.view.addSubview(tab)
//        self.navigationController?.navigationBar.isHidden = true
//        self.tabBarController?.tabBar.isHidden = true
        /*
        let v1 = UIView.init(frame: CGRect.Xinit(x: 20, y: 300, width: 200, height: 50))
        v1.backgroundColor = UIColor.green
        self.view.addSubview(v1)
        let v2 = UIView.init()
//        (frame: CGRect.Xinit(x: 20, y: 330, width: 200, height: 50))
        v2.backgroundColor = UIColor.blue
//        self.view.addSubview(v2)
        self.view.insertSubview(v2, belowSubview: v1)
        v2.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.top.equalTo(v1)
        }
 */
//        数据源绑定到viewmodel输入源
        dataVar.asObservable().bind(to: viewModel.input).disposed(by: disp)
//        viewmodel输出绑定到UI
        viewModel.output.asDriver(onErrorJustReturn: []).drive(tab.rx.items(cellIdentifier: "cell", cellType: TestCell.self)){ (row,item,cell) in
            cell.nameLab.text = item.name
            cell.ageLab.text = item.age
            }.disposed(by: disp)
        dataVar.value = self.reData() //关键，更新数据源
        
//        点击事件
        tab.rx.itemSelected.map{$0}.subscribe(onNext:{
            self.tab.deselectRow(at: $0, animated: true)
            guard let mod:TestModel = try? self.tab.rx.model(at: $0)else {return}
            UIAlertController.Alert(VC: self, title: mod.name!, okHandle: {_ in })
        })
        .disposed(by: disp)
        
        tab.addRefresher(downHandler: {
            self.dataVar.value = self.reData()
        }, upHandler: {
            self.dataVar.value += self.reData()
        }, disposeBag: disp)
     }
    }


