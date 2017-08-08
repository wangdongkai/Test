//
//  ExamineDetailViewController.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import MJExtension

private let identifier = "ExamineDetailsViewCell"

class ExamineDetailViewController: UICollectionViewController {

    var model: ExamineMainModel?
    var dataArray: [ExamineItemModel] = [ExamineItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        setupNetwork()
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ExamineDetailsViewCell
        
        let model = self.dataArray[indexPath.row]
        
        model.totalCount = self.dataArray.count
        model.currentCount = indexPath.row

        cell.model = model
        
        
        return cell
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
    }
    // MARK: UICollectionViewDelegate

    
}

private extension ExamineDetailViewController {
    
    func setup() {
        
        title = self.model?.name

        self.view.backgroundColor = UIColor.white
        self.collectionView?.backgroundColor = UIColor.clear
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.barButtonItemWith(image: "submit", target: self, action: #selector(ExamineDetailViewController.submitClick)),
            UIBarButtonItem.barButtonItemWith(image: "star", target: self, action: #selector(ExamineDetailViewController.collectClick))
        ]
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0

        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height - 64)
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.register(UINib.init(nibName: "ExamineDetailsViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)

        self.collectionView?.isPagingEnabled = true
        
    }
    
    func setupNetwork() {
        
        // MAR: - 提交答案请求
        /*
        let p =
            ["exerciseGroupId": "8a2aa19d5d9cd52a015d9d2aa708143d",
             "subjectId": "",
            "exerciseRecordId": "",
            "exerciseExtendId": "",
            "currTitleNum": 1,
            "status": 0,
            "type": 4,
            "doCount": 1,
            "correctCount": 1,
            "allCount": 174,
            "submitTime": "2017-08-07 12:12:12",
            "submitType": 0,
            "items": [
                ["exerciseId": "8a29e1345d9cd620015d9d2b198f4b2b", "type": 1, "answer": "C", "correct": 1]
                ]] as [String : Any]
    
        guard let jsonData = try? JSONSerialization.data(withJSONObject: p, options: .prettyPrinted) else {
            
            return
        }
        
        var json = NSString.init(data: jsonData, encoding: 0)
        
        
        print(json!)
        */
        
        let param = ["groupId": model?.groupId! ?? "", "exerciseRecordId": model?.exerciseRecordId! ?? "", "getExercise": true, "getAnswer": true] as [String : Any]
        
        NetworkTool.shareInstance.get("http://www.qxueyou.com/qxueyou/exercise/Exercise/examExercise", parameters: param, progress: nil, success: { (_, data: Any?) in
            
            guard let dict = data as? [String: Any] else {
                
                return
            }

            let detailModel: ExamineDetailModel = ExamineDetailModel.mj_object(withKeyValues: dict)
                        
            self.dataArray = detailModel.items!
            
            self.collectionView?.reloadData()
            
        }) { (_, error: Error) in
            
            print(error)
        }
    }
}

private extension ExamineDetailViewController {
    
    @objc func collectClick() {
        
        
    }
    
    @objc func submitClick() {
    
        
    }
}
