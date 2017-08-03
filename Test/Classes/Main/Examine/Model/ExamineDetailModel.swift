//
//  ExamineDetailModel.swift
//  Test
//
//  Created by wangdongkai on 17/8/2.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineDetailModel: NSObject {

    var items: [ExamineItemModel]?
    var answers: [ExamineAnswerModel]?
    
    override func mj_keyValuesDidFinishConvertingToObject() {
        if self.items?.isEmpty == false {
            self.items = ExamineItemModel.mj_objectArray(withKeyValuesArray: self.items).copy() as? [ExamineItemModel]
        }
        
        if self.answers?.isEmpty == false{
            self.answers = ExamineAnswerModel.mj_objectArray(withKeyValuesArray: self.items).copy() as? [ExamineAnswerModel]
        }
        
    }
    
    
}
