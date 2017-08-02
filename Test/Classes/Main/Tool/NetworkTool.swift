//
//  NetworkTool.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import AFNetworking

enum RequestMethod {
    case GET
    case POST
}

class NetworkTool: AFHTTPSessionManager {

    static let shareInstance : NetworkTool = {
       
        let tools = NetworkTool()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        if let cookie = UserDefaults.standard.object(forKey: "Cookie") as! String? {
            
            tools.requestSerializer.setValue(cookie, forHTTPHeaderField: "Cookie")

        }
        

        return tools
        
    }()
    
    
}

extension NetworkTool {
    
    func request(method: RequestMethod, url: String, param: Any?, finished: @escaping(_ task: URLSessionDataTask,_ success: Any?, _ error: Error?) -> ()) {
        
        let successBlock = { (task: URLSessionDataTask, data: Any) -> Void in
        
            finished(task, data, nil)
        }
        
        let failureBlock = { (task: URLSessionDataTask?, failure: Error) -> Void in
            
            finished(task!, nil, failure)
        }
        
        switch method {
        case .GET:
            
            get(url, parameters: param, progress: nil, success: successBlock, failure: failureBlock)
            break
        case .POST:
            
            post(url, parameters: param, progress: nil, success: successBlock, failure: failureBlock)
            break
        }
    }
}

