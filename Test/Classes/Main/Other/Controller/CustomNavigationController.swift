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

        let button = UIButton(type: .custom)
        button.sizeToFit()
        button.setImage(UIImage.init(named: "back"), for: .normal)
        button.setImage(UIImage.init(named: "back"), for: .highlighted)
        button.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        // Do any additional setup after loading the view.
    }

    
}

private extension CustomNavigationController {
    
    @objc func backClick() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
