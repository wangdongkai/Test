//
//  CircleButton.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class CircleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _ = UIBezierPath.init(arcCenter: self.center, radius: self.frame.midX / 2.0, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
