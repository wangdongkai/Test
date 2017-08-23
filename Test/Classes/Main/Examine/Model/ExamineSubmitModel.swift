//
//  ExamineSubmitModel.swift
//  Test
//
//  Created by 王东开 on 2017/8/8.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineSubmitModel: NSObject {

    var exerciseGroupId: String?
    var subjectId: String?
    var exerciseRecordId: String?
    var exerciseExtendId: String?
    var currTitleNum: Int = 0
    var status: Int = 0
    var type: Int = 4
    var doCount: Int = 0
    var correctCount: Int = 0
    var allCount: Int64 = 0
    var submitTime: String?
    var submitType: Int = 0
    
    var items: [ExamineSubmitItemModel] = [ExamineSubmitItemModel]()
    
    
}


class ExamineSubmitItemModel: NSObject {
    
    var exerciseId: String = ""
    var type: Int64 = 0
    var answer: String = ""     
    var correct: Int64 = 0
    
}
