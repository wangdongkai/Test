//
//  ExamineMainModel.swift
//  Test
//
//  Created by wangdongkai on 17/8/2.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
/*
"groupId":"组id",
"classId":班级id,
"collegeCourseId":科目id,
"orgId":机构id,
"subjectId":课程id,
"name":"组名",
"type":组类型 ,
"updateTime":更新时间,
"answerUpdateTime":本套题答题更新时间,
"faultUpdateTime":本套题错题本更新时间,
"favorUpdateTime":本套题收藏本更新时间,
"allCount":题目总数,
"exerciseTime":"考试时间",
"exerciseStrategy":" 做题方式（1：未做题优先  2：错题优先）",
"exerciseSource":"做题来源(1:练习题库  2：考试题库  3：家庭作业)",
"exerciseMode":" 做题模式(1:练习  2：考试)",
"exerciseRecordId":"记录id",
"doCount": 做题个数,
"correctCount": 正确个数,
"submitNumber":已提交人数(家庭作业),
"currTitleNumber":当前做题序号,
"status":做题状态(0：未提交 1：已提交),
"completionRate": 完成率,
"accuracy": 正确率,
"score": 分数,
"extendAllCount":错题本、收藏本总数,
"classAccuracy":班级正确率,
"classRank":排名,
"repeatFlag":是否可重做   true 可以重做  false 不能
 */

class ExamineMainModel: NSObject {

    // 组id
    var groupId: String?
    // 班级id
    var classId: String?
    // 科目id
    var collegeCourseId: String?
    // 机构id
    var orgId: String?
    // 课程id
    var subjectId: String?
    // 名字
    var name: String?
    // 组类型
    var type: Int64?
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
    // 本套题答题更新时间
    var answerUpdateTime: NSNumber?
    // 本套题错题本更新时间
    var faultUpdateTime: NSNumber?
    // 本套题收藏本更新时间
    var favorUpdateTime: NSNumber?
    // 总数
    var allCount: Int64 = 0
    // 考试时间
    var exerciseTime: NSNumber? {
        
        didSet {
            
            guard let time = exerciseTime else {
                
                return
            }
            
            exerciseTimer = time.intValue * 60
        }
    }
    var exerciseTimer: Int = 0
    // 做题方式（1：未做题优先  2：错题优先）
    var exerciseStrategy: NSNumber?
    // 做题来源(1:练习题库  2：考试题库  3：家庭作业)
    var exerciseSource: NSNumber?
    // 做题模式(1:练习  2：考试)
    var exerciseMode: NSNumber?
    // 记录ID
    var exerciseRecordId: String?
    // 完成数
    var doCount: Int64 = 0
    // 正确个数
    var correctCount: Int64 = 0
    // 已提交人数(家庭作业)
    var submitNumber: Int64 = 0
    // 当前做题序号
    var currTitleNumber: Int64 = 0
    // 状态
    var status: String? {
        didSet {
            
            if status == "0" {
                // 已做未提交和未做未提交
                buttonStatus = doCount > 0 ? 2 : 0
            } else {
                // 已提交
                buttonStatus = 1
            }
        
        }
    }
    var buttonStatus: Int = 0

    // 完成率
    var completionRate: NSNumber?
    // 正确率
    var accuracy: NSNumber?
    // 分数
    var score: NSNumber?
    // 错题本、收藏本总数
    var extendAllCount: Int64?
    // 班级正确率
    var classAccuracy: String?
    // 排名
    var classRank: String?
    // 是否可以重做
    var repeatFlag: Bool?
    
    
}
