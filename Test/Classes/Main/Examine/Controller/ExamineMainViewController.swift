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
import RealmSwift

private let identifier = "ExamineMainViewCell"

class ExamineMainViewController: UITableViewController {

    var model: UserModel?
    
    var modelArray: Array<ExamineMainModel>  = [ExamineMainModel]()
    
    fileprivate var page: Int = 2
    fileprivate var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        setupHeader()

        setupFooter()
        
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
           
            let detailVC = ExamineDetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
            
            if self.modelArray.count == 0 {
                return
            }
            
            detailVC.model = self.modelArray[indexPath.row]
            detailVC.index = Int(model.currTitleNumber)
            detailVC.hasSubmit = true
            
            navigationController!.pushViewController(detailVC, animated: true)

            
        } else {
            
            let detailVC = ExamineDetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
            
            if self.modelArray.count == 0 {
                return
            }
            
            detailVC.model = self.modelArray[indexPath.row]
            detailVC.index = Int(model.currTitleNumber)
            detailVC.hasSubmit = false
            navigationController!.pushViewController(detailVC, animated: true)
        }
        
    }
}
private extension ExamineMainViewController {
    
    func setup() {
        
        title = self.model?.courseName ?? "测试"
        
        self.view.backgroundColor = UIColor.white

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 72
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
    
    
    func setupFooter() {
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(ExamineMainViewController.setupMoreData))
        footer?.setTitle("点击加载更多", for: .idle)
        footer?.setTitle("加载更多中...", for: .refreshing)
        footer?.setTitle("无更多数据", for: .noMoreData)
        
        self.tableView.mj_footer = footer
        
    }
}

private extension ExamineMainViewController {
    
    @objc func setupNetwork() {
        
        if isLoading == true {
            
            tableView.mj_header.endRefreshing()
            return
        }
        if self.modelArray.count != 0 {
            self.modelArray.removeAll()
            self.tableView.mj_footer.resetNoMoreData()
            page = 2
            
        }
        
        isLoading = true
        weak var weakSelf = self
        
        NetworkTool.shareInstance.get("http://www.qxueyou.com/qxueyou/exercise/Exercise/examsListNew", parameters: ["page": "1", "limit": "10"], progress: nil, success: { (_, data: Any?) in
            
            guard let result = data as? [Dictionary<String, Any>] else {
                
                return
            }
            
            weakSelf?.setupRealm(result: result)
            for dict in result {
                
                let item = ExamineMainModel.mj_object(withKeyValues: dict)
                
                if UserDefaults.standard.integer(forKey: "\(item!.groupId!)") == 0 {
                    
                    UserDefaults.standard.set(item!.exerciseTimer, forKey: "\(item!.groupId!)")
                    UserDefaults.standard.synchronize()

                }
                
                weakSelf?.isLoading = false
                weakSelf!.modelArray.append(item!)
                
            }
            
            weakSelf?.tableView.reloadData()
            weakSelf?.tableView.mj_header.endRefreshing()
            
        }) { (_, error: Error) in
            
            weakSelf?.isLoading = false
            weakSelf?.tableView.mj_header.endRefreshing()
            
            print(error)
            
        }
        
    }

    @objc func setupMoreData() {
        
        if isLoading == true {
            
            tableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        weak var weakSelf = self
        isLoading = true
        
        NetworkTool.shareInstance.get("http://www.qxueyou.com/qxueyou/exercise/Exercise/examsListNew", parameters: ["page": "\(page)", "limit": "10"], progress: nil, success: { (_, data: Any?) in
            
            guard let result = data as? [Dictionary<String, Any>] else {
                
                weakSelf!.tableView.mj_footer.endRefreshingWithNoMoreData()

                return
            }
            
            if result.count == 0 {// 无更多数据
                
                weakSelf!.tableView.mj_footer.endRefreshingWithNoMoreData()
                weakSelf?.isLoading = false
                return
            }
            
            weakSelf?.setupRealm(result: result)
            for dict in result {
                
                let item = ExamineMainModel.mj_object(withKeyValues: dict)
                weakSelf!.modelArray.append(item!)
                
            }
            weakSelf?.isLoading = false

            weakSelf?.tableView.reloadData()
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.page += 1
        }) { (_, error: Error) in
            
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.isLoading = false

            print(error)
            
        }

    }
}

private extension ExamineMainViewController {
    
    /// 数据库添加文件
        func setupRealm(result: [Dictionary<String, Any>]) {
        
        DispatchQueue(label: "background").async {
            
            autoreleasepool{
                
                let realm = try! Realm()
                
                realm.beginWrite()
                
                for dict in result {
                    
                    let item = ExamineMainModel.mj_object(withKeyValues: dict)
                    let value: [String: Any] = ["groupId": item!.groupId, "name": item!.name, "exerciseTime": item!.exerciseTimer,"allCount": Float(item!.allCount), "status": item!.status, "exerciseRecordId": item?.exerciseRecordId, "currTitleNumber": item!.currTitleNumber, "completionRate": item!.completionRate?.floatValue ?? 0, "accuracy": item!.accuracy?.floatValue ?? 0, "score": item!.score?.floatValue ?? 0, "classAccuracy": item!.classAccuracy, "classRank": item!.classRank]
                    let tanTopic = realm.objects(TopicList.self).filter("groupId = '\(item!.groupId!)'")
                    
                    if tanTopic.count == 0 {
                        realm.create(TopicList.self, value: value, update: false)
                    } else {
                        
                        realm.create(TopicList.self, value: value, update: true)
                    }
                    
                }
                
                try! realm.commitWrite()
            }
        
        }
    }
}
