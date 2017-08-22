//
//  TopicDetail.swift
//  Test
//
//  Created by 王东开 on 2017/8/22.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class TopicDetail: Object {
    
    dynamic var exerciseId: String? = nil
    dynamic var title: String? = nil
    dynamic var type: Int = 0
    dynamic var updateTime: Float = 0
    dynamic var answer: String? = nil
    var options = List<TopicOptions>()
    dynamic var analisisResult:TopicAnalisis?
    var imgs = List<TopicImgs>()
    dynamic var maxScore: Float = 0
    dynamic var avarageScore: Float = 0
    
    override static func primaryKey() -> String {
        
        return "exerciseId"
    }

}

class TopicOptions: Object {
    
    dynamic var optionId: String? = nil
    dynamic var content: String? = nil
    dynamic var optionOrder: String? = nil
    dynamic var exerciseId: String? = nil
    var imgs = List<TopicImgs>()
    
    override static func primaryKey() -> String {
        
        return "optionId"
    }

}

class TopicImgs: Object {
    
    dynamic var imgId: String? = nil
    dynamic var exerciseObjectId: String? = nil
    dynamic var imgPath: String? = nil
    
    override static func primaryKey() -> String {
        
        return "imgId"
    }
}

class TopicAnalisis: Object {
    
    dynamic var allAccuracy: Float = 0
    dynamic var analysis: String? = nil
    dynamic var submitAllNumber: Int = 0
    dynamic var accuracy: Float = 0
    dynamic var submitNumber: Int = 0
    dynamic var submitErrorNumber: Int = 0
}
