//
//  CustomNavigationController.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barTintColor = UIColor(red: 47/255.0, green: 154/255.0, blue: 255/255.0, alpha: 1)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Do any additional setup after loading the view.
    }

    
}
