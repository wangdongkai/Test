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
    var type: Int64 = 0{
        didSet {
            if self.type == 1 {
                
                typeString = "【单选】"
            } else if self.type == 2 {
                
                typeString = "【多选】"
            } else {
                
                typeString = "【判断】"
            }

        }
    }
    var typeString: String?
    var updateTime: Int64?
    var answer: String?
    var options: [ExamineOptionModel]?
    var imgs: [ExamineImgModel]?
    var analisisResult: [String: Any]?
    var maxScore: NSNumber?
    var averageScore: NSNumber?
    
    var totalCount: Int = 0
    var currentCount: Int = 0
    
    override func mj_keyValuesDidFinishConvertingToObject() {
        if self.options?.isEmpty == false {
            self.options = ExamineOptionModel.mj_objectArray(withKeyValuesArray: self.options).copy() as? [ExamineOptionModel]
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
    var optionOrder: String? {
        didSet {
            if optionOrder == "True" {
                optionAnswer = "B"
                optionContent = "错误"
            } else if optionOrder == "False" {
                optionAnswer = "A"
                optionContent = "正确"
            } else {
                optionAnswer = optionOrder
                optionContent = content
            }
        }
    }
    
    var optionAnswer: String?
    var optionContent: String?
    
    var exerciseItemId: String?
    var score: Int64?
    var exerciseItemScoreId: String?
    var imgs: [ExamineImgModel]?
    
}

class ExamineImgModel: NSObject {
    
    var imgId: String?
    var exerciseObjectId: String?
    var imgPath: String? {
        didSet{
            guard let path = self.imgPath else {
                return
            }
            imgURL = "http://www.qxueyou.com/qxueyou\(path)"
        }
    }
    var imgURL: String?
    
    var imgOrder: Int64?
    var objectType: Int64?
}
