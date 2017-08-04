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

extension UIColor {
    
    class func colorWithHex(color: NSString, alpha: CGFloat) -> UIColor {
        
        // 去除特殊符号
        var cString = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        
        if cString.length < 6 {
            return UIColor.clear
        }
        
        if cString.hasPrefix("0X") {
            
            cString = cString.substring(from: 2) as NSString
        }
        
        if cString.hasPrefix("#") {
            
            cString = cString.substring(from: 1) as NSString
        }
        
        if cString.length != 6 {
            return UIColor.clear
        }
        
        var range = NSRange()
        
        range.length = 2
        
        range.location = 0
        let rStr = cString.substring(with: range) as NSString
        
        range .location = 2
        let gStr = cString.substring(with: range) as NSString
        
        range.location = 4
        let bStr = cString.substring(with: range) as NSString
        
        var r: uint = 0, g: uint = 0, b: uint = 0
        
        Scanner.init(string: rStr as String).scanHexInt32(&r)
        Scanner.init(string: gStr as String).scanHexInt32(&g)
        Scanner.init(string: bStr as String).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/256.0, green: CGFloat(g)/256.0, blue: CGFloat(b)/256.0, alpha: alpha)
    }
}
