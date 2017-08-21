//
//  ExamineMainViewController.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh
import FMDB

private let identifier = "ExamineMainViewCell"

class ExamineMainViewController: UITableViewController {

    var model: UserModel?
    
    var modelArray: Array<ExamineMainModel>  = [ExamineMainModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        setupHeader()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.mj_header.beginRefreshing()
        
    }
        // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return modelArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ExamineMainViewCell
        cell.selectionStyle = .none
        
        cell.model = self.modelArray[indexPath.row]
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.modelArray[indexPath.row]
        
        if model.buttonStatus == 1 { //已提交
           
            let vc = ExamineAnaysisViewController(collectionViewLayout: UICollectionViewFlowLayout())
            
            if self.modelArray.count == 0 {
                return
            }
            
            vc.model = self.modelArray[indexPath.row]

            
            
            navigationController!.pushViewController(vc, animated: true)

            
        } else {
            
            let detailVC = ExamineDetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
            
            if self.modelArray.count == 0 {
                return
            }
            
            detailVC.model = self.modelArray[indexPath.row]
            
            navigationController!.pushViewController(detailVC, animated: true)
        }
        
        
        
    }
}
private extension ExamineMainViewController {
    
    func setup() {
        
        title = self.model?.courseName ?? "测试"
        
        self.view.backgroundColor = UIColor.white

        self.tableView.rowHeight = 72
        self.tableView.register(UINib.init(nibName: "ExamineMainViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        self.tableView.tableFooterView = UIView()

    }
    
    func setupHeader() {
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(ExamineMainViewController.setupNetwork))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放以更新", for: .pulling)
        header?.setTitle("加载中", for: .refreshing)
        tableView.mj_header = header
        
    }
    
    
    func setupDataBase() {
        
        
    }
}

private extension ExamineMainViewController {
    
    @objc func setupNetwork() {
        
        if self.modelArray.count != 0 {
            self.modelArray.removeAll()
            
        }
        weak var weakSelf = self
        
        NetworkTool.shareInstance.get("http://www.qxueyou.com/qxueyou/exercise/Exercise/examsListNew", parameters: ["page": "1", "limit": "10"], progress: nil, success: { (_, data: Any?) in
            
            guard let result = data as? [Dictionary<String, Any>] else {
                
                return
            }
            
            
            // 插入数据
            /*
            let name = UserDefaults.standard.object(forKey: "username") as! String
            
            let path: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
            
            let sqlPath = path.appendingPathComponent("\(name).sqlite")
           // let queue = FMDatabaseQueue.init(path: sqlPath)
            let db = FMDatabase(path: sqlPath)
            
            */
            
            for dict in result {
                
                let item = ExamineMainModel.mj_object(withKeyValues: dict)
                
                weakSelf!.modelArray.append(item!)
                print(dict["groupId"]!)
                
                UserDefaults.standard.set(dict["classAccuracy"] as! String, forKey: "\(dict["groupId"]!)classAccuracy")
                UserDefaults.standard.set(dict["classRank"] as! String, forKey: "\(dict["groupId"]!)classRank")

                let time = UserDefaults.standard.integer(forKey: dict["groupId"] as! String)
                if time == 0 {
                    
                    UserDefaults.standard.set(item?.exerciseTimer , forKey: dict["groupId"] as! String)
                    UserDefaults.standard.synchronize()
                    
                }
                
                /*
                if db.open() {
                   
                    
                    do {
                        let res = try db.executeQuery("SELECT * FROM t_test", values: nil)
                        print(res)
                        
                        let r = res.next()
                        
                        if r == false {
                            
                            // groupId text, classId text, orgId text, name text, type integer, exerciseTime text, allCount integer, orderNum integer, updateTime integer, answerUpdateTime double, faultUpdateTime double, faultCount integer, exerciseRecordId text, status text, currTitleNumber text, doCount integer, correctCount integer, submitNumber integer, classAccuracy text, classRank text 20
                            
                            do {
                                try db.executeUpdate("INSERT INTO t_test (answerUpdateTime, exerciseRecordId, classAccuracy, faultUpdateTime, type, exerciseTime, classRank, groupId, submitNumber, orderNum, faultCount, allCount, updateTime, currTitleNumber, name, doCount, classId, correctCount, orgId, status) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", values: [dict["answerUpdateTime"], dict["exerciseRecordId"], dict["classAccuracy"], dict["faultUpdateTime"], dict["type"], dict["exerciseTime"], dict["classRank"], dict["groupId"], dict["submitNumber"], dict["orderNum"], dict["faultCount"],dict["allCount"], dict["updateTime"], dict["currTitleNumber"], dict["name"], dict["doCount"], dict["classId"], dict["correctCount"], dict["orgId"], dict["status"]])
                                
                            } catch {
                                
                                print("failed: \(error.localizedDescription)")
                            }

                        } else {
                            
                            while res.next() {
                                
                                if let groupId = res.string(forColumn: "groupId") {
                                    
                                    let group = dict["groupId"] as! String
                                    if group != groupId {
                                        
                                        do {
                                            try db.executeUpdate("INSERT INTO t_test (answerUpdateTime, exerciseRecordId, classAccuracy, faultUpdateTime, type, exerciseTime, classRank, groupId, submitNumber, orderNum, faultCount, allCount, updateTime, currTitleNumber, name, doCount, classId, correctCount, orgId, status) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", values: [dict["answerUpdateTime"], dict["exerciseRecordId"], dict["classAccuracy"], dict["faultUpdateTime"], dict["type"], dict["exerciseTime"], dict["classRank"], dict["groupId"], dict["submitNumber"], dict["orderNum"], dict["faultCount"],dict["allCount"], dict["updateTime"], dict["currTitleNumber"], dict["name"], dict["doCount"], dict["classId"], dict["correctCount"], dict["orgId"], dict["status"]])

                                            
                                        } catch {
                                            
                                            print("failed: \(error.localizedDescription)")
                                        }
                                        
                                        
                                    }
                                }

                            }
                        }
                                    
                    } catch {
                        
                        print(error)
                    }
                    

                }
            
                db.close()
  */
            }
            

                
            weakSelf?.tableView.reloadData()
            weakSelf?.tableView.mj_header.endRefreshing()
            
        }) { (_, error: Error) in
            
            weakSelf?.tableView.mj_header.endRefreshing()
            
            print(error)
            
        }
        
        
    }

}
