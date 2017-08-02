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
    var type: Int64?
    var updateTime: Int64?
    var answer: String?
    var options: [ExamineOptionModel]?
    var analisisResult: [ExamineAnalisisResultModel]?
    var imgs: [ExamineImgModel]?
    var maxScore: NSNumber?
    var averageScore: NSNumber?
    
    override func mj_keyValuesDidFinishConvertingToObject() {
        if self.options?.isEmpty == false {
            self.options = ExamineOptionModel.mj_objectArray(withKeyValuesArray: self.options).copy() as? [ExamineOptionModel]
        }
        
        if self.analisisResult?.isEmpty == false {
            self.analisisResult = ExamineAnalisisResultModel.mj_objectArray(withKeyValuesArray: self.analisisResult).copy() as? [ExamineAnalisisResultModel]
        }
        
        if self.imgs?.isEmpty == false {
            self.imgs = ExamineImgModel.mj_objectArray(withKeyValuesArray: self.imgs).copy() as? [ExamineImgModel]
        }

    }
}

class ExamineOptionModel: NSObject {
    
    var optionId: String?
    var checked: Bool?
    var content: String?
    var optionOrder: String?
    var exerciseItemId: String?
    var score: Int64?
    var exerciseItemScoreId: String?
    var imgs: [ExamineImgModel]?
    
}

class ExamineImgModel: NSObject {
    
    var imgId: String?
    var exerciseObjectId: String?
    var imgPath: String?
    var imgOrder: Int64?
    var objectType: Int64?
}

class ExamineAnalisisResultModel: NSObject {
    
    var allAccuracy: Int64?
    var analysis: String?
    var submitAllNumber: Int64?
    var usualFaultAnswers: String?
    var exerciseAnalisisUId: String?
    var accuracy: Int64?
    var submitNumber: Int64?
    var submitErrorNumber: Int64?
    
}
