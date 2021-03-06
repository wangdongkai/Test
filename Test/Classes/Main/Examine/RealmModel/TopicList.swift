//
//  TopicList.swift
//  Test
//
//  Created by 王东开 on 2017/8/22.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import Foundation

import RealmSwift

class TopicList: Object {

    dynamic var groupId: String? = nil
    dynamic var name: String? = nil
    dynamic var exerciseTime: Float = 0
    dynamic var allCount: Float = 0
    dynamic var exerciseRecordId: String? = nil
    dynamic var status: String? = nil
    dynamic var currTitleNumber: Float = 0
    dynamic var completionRate: Float = 0
    dynamic var accuracy: Float = 0
    dynamic var score: Float = 0
    dynamic var classAccuracy: String = ""
    dynamic var classRank: String = ""

    override static func primaryKey() -> String {
        
        return "groupId"
    }
}
