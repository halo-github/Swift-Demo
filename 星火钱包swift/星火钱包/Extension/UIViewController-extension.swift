//
//  UIViewController-extension.swift
//  星火钱包
//
//  Created by 刘峰 on 2018/2/26.
//  Copyright © 2018年 xeenho. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static func currentViewController(base:UIViewController? = UIApplication.shared.keyWindow?.rootViewController) ->UIViewController {
        if let nav = base as? UINavigationController {
            return self.currentViewController(base:nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return self.currentViewController(base:tab.selectedViewController)
        }
        if let vc = base?.presentedViewController {
            return self.currentViewController(base:vc.presentedViewController)
        }
        return base!
    }
    static func currentNavigationViewController(base:UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UINavigationController {
        var nav:UINavigationController?
        
        if let nav  = self.currentViewController().navigationController {
            return nav
        }
        return nav!
    }
    
    static func currentUITabBarController(base:UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UITabBarController {
        var tab:UITabBarController?
        
        if let tab  = self.currentViewController().tabBarController {
            return tab
        }
        return tab!
    }
}


