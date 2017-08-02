//
//  ExamineItemsModel.swift
//  Test
//
//  Created by wangdongkai on 17/8/2.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineItemModel: NSObject {
    
    var exerciseId: String?
    var title: String?
    var type: NSNumber?
    var updateTime: NSNumber?
    var answer: String?
    var options: [ExamineOptionModel]?
    var analisisResult: [ExamineAnalisisResultModel]?
    var imgs: [ExamineImgModel]?
    var maxScore: NSNumber?
    var averageScore: NSNumber?
    
}

class ExamineOptionModel: NSObject {
    
    var optionId: String?
    var checked: Bool?
    var content: String?
    var optionOrder: String?
    var exerciseItemId: String?
    var score: NSNumber?
    var exerciseItemScoreId: String?
    var imgs: [ExamineImgModel]?
    
}

class ExamineImgModel: NSObject {
    
    var imgId: String?
    var exerciseObjectId: String?
    var imgPath: String?
    var imgOrder: String?
    var objectType: String?
}

class ExamineAnalisisResultModel: NSObject {
    
    var allAccuracy: NSNumber?
    var analysis: String?
    var submitAllNumber: NSNumber?
    var usualFaultAnswers: String?
    var exerciseAnalisisUId: String?
    var accuracy: NSNumber?
    var submitNumber: NSNumber?
    var submitErrorNumber: NSNumber?
    
}
