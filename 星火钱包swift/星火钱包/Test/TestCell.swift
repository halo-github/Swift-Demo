//
//  TestCell.swift
//  星火钱包
//
//  Created by 刘峰 on 2018/2/2.
//  Copyright © 2018年 xeenho. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class TestCell: UITableViewCell {
   lazy var nameLab = UILabel()
   lazy var ageLab = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLab.textColor = .red
        self.addSubview(nameLab)
        ageLab.textColor = .blue
        self.addSubview(ageLab)
        
        nameLab.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(20)
            make.left.equalTo(50)
            make.centerY.equalToSuperview()
        }
        ageLab.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(20)
            make.right.equalTo(-50)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
