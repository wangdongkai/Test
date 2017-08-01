//
//  UserModel.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    var account: String?
    var className: String?
    var courseName: String?
    var orgName: String?
    var userName: String?
    var cookie: String?
    
    init(dict: [String: Any]) {
        super.init()
        self.setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
