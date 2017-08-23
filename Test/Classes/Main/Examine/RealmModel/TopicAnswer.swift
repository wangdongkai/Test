//
//  TopicAnswer.swift
//  Test
//
//  Created by 王东开 on 2017/8/22.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class TopicAnswer: Object {

    dynamic var answerUId: String? = nil
    dynamic var answer: String? = nil
    dynamic var correct: Int = 0
    dynamic var createTime: Float = 0
    dynamic var creator: String? = nil
    dynamic var exerciseItemId: String? = nil
    dynamic var exerciseRecordId: String? = nil
    dynamic var userId: String? = nil
    dynamic var lastAnswer: String? = nil
    dynamic var answerValue: String? = nil
    dynamic var updateStatus: Int = 0
    override static func primaryKey() -> String {
        
        return "exerciseItemId"
    }

}
