//
//  ExamineMainModel.swift
//  Test
//
//  Created by wangdongkai on 17/8/2.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineMainModel: NSObject {

    // 组id
    var groupId: String?
    // 名字
    var name: String?
    // 完成数
    var doCount: NSNumber?
    // 总数
    var allCount: NSNumber?
    // 考试时间
    var exerciseTime: NSNumber?
    // 答题更新时间
    var updateTime: NSNumber? {
        didSet {
            let time: TimeInterval = updateTime as! TimeInterval
            let date = Date(timeIntervalSince1970: (time/1000.0))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            update = formatter.string(from: date)
        }
    }
    var update: String?
    
    init(dict: [String: Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
