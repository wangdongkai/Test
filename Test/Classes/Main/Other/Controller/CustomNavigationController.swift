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
        
        /*
        let pan = UIPanGestureRecognizer.init(target: self.interactivePopGestureRecognizer, action: Selector("handleNavigationTransition:"))
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        
        self.interactivePopGestureRecognizer?.isEnabled = false
        
        
        print(self.interactivePopGestureRecognizer)
        
         */
        
        // Do any additional setup after loading the view.
    }

    
}

extension CustomNavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWith(image: "back", target: self, action: #selector(CustomNavigationController.backClick))
        }
        
        super.pushViewController(viewController, animated: animated)
    }
}
private extension CustomNavigationController {
    
    @objc func backClick() {
        
        self.popViewController(animated: true)
        
    }
}
