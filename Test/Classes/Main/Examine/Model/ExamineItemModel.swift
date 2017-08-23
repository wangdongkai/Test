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
    var updateTime: Int64 = 0 {
        didSet {
            let time: TimeInterval = Double(updateTime) 
            let date = Date(timeIntervalSince1970: (time/1000.0))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            update = formatter.string(from: date)
            
        }
    }

    var update: String? = nil
    var answer: String? {
        
        didSet {
            
            ans = answer?.replacingOccurrences(of: ",", with: "")
        }
    }
    var ans: String?
    var chooseAnswer: String?
    
    var options: [ExamineOptionModel]?
    var imgs: [ExamineImgModel]?
    var analisisResult: [String: Any]?
    var maxScore: NSNumber?
    var averageScore: NSNumber?
    
    var totalCount: Int = 0
    var currentCount: Int = 0
    var exerciseGroupId: String?
    var exerciseRecordId: String?
    var exerciseExtendId: String?
    
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
                optionContent = "正确"
            } else if optionOrder == "False" {
                optionAnswer = "A"
                optionContent = "错误"
            } else {
                optionAnswer = optionOrder
                optionContent = content
            }
        }
    }
    
    var optionAnswer: String?
    var optionContent: String?
    var optionState: Bool = false
    
    var exerciseItemId: String?
    var score: Int64?
    var exerciseItemScoreId: String?
    var imgs: [ExamineImgModel]?
    
    override func mj_keyValuesDidFinishConvertingToObject() {
        
        if self.imgs?.isEmpty == false {
            self.imgs = ExamineImgModel.mj_objectArray(withKeyValuesArray: self.imgs).copy() as? [ExamineImgModel]
        }

    }
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
