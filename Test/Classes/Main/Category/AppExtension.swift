//
//  AppExtension.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import TYAttributedLabel

extension UIBarButtonItem {
    
    class func barButtonItemWith(image: String, target: Any?, action: Selector) -> UIBarButtonItem {
        
        let button = UIButton(type: .custom)
        button.sizeToFit()
        button.setImage(UIImage.init(named: image), for: .normal)
        button.setImage(UIImage.init(named: image), for: .highlighted)
        button.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
        
    }
}

