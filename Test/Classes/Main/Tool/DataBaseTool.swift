//
//  DataBaseTool.swift
//  Test
//
//  Created by 王东开 on 2017/8/17.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import FMDB

class DataBaseTool: NSObject {

    static let instance: DataBaseTool = {
        
        let tool = DataBaseTool()
        
        return tool
    }()
    
    func setupDataBase(name: String) -> Bool {
        
        let path: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
        
        let sqlPath = path.appendingPathComponent("\(name).sqlite")
        let db = FMDatabase(path: sqlPath)
        
        return db.open()
        
    }

    
}
