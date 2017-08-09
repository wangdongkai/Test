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
    var submitModel: ExamineSubmitModel = ExamineSubmitModel()
    
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
        
        let point = self.view.convert(self.collectionView!.center, to: self.collectionView)
        let index = self.collectionView?.indexPathForItem(at: point)
        
        self.submitModel.currTitleNum = index!.item
        
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        let point = self.view.convert(self.collectionView!.center, to: self.collectionView)
        let index = self.collectionView?.indexPathForItem(at: point)
        
        let cell = collectionView?.cellForItem(at: index!) as! ExamineDetailsViewCell
        
        if cell.submitModel.answer.characters.count > 0 {
            
            self.submitModel.currTitleNum = index!.item
            
            if self.submitModel.items.contains(cell.submitModel) == false{
                
                self.submitModel.items.append(cell.submitModel)

            }
            
        }
        
    }
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
    
        self.submitModel.allCount = self.model!.allCount
        self.submitModel.doCount = self.submitModel.items.count
        for i in 0..<self.submitModel.items.count {
            
            let item = self.submitModel.items[i]
            if item.correct == 1 {
                
                self.submitModel.correctCount += 1
            }
        }
        self.submitModel.exerciseGroupId = self.dataArray[0].exerciseGroupId
        self.submitModel.exerciseRecordId = self.dataArray[0].exerciseRecordId
        self.submitModel.exerciseExtendId = self.dataArray[0].exerciseExtendId

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.submitModel.submitTime = formatter.string(from: Date())
        
        let dict = self.submitModel.mj_keyValues()
    
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict!, options: .prettyPrinted) else {
            
            return
        }
        
        let encoding = String(data: jsonData, encoding: .utf8)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = "http://www.qxueyou.com/qxueyou/exercise/Exercise/exerAnswers?answers=\(encoding!)"
        
        NetworkTool.shareInstance.request(method: .POST, url: url, param: nil) { (_, success: Any?, error: Error?) in
            
            guard let data = success as? [String: Any] else {
                
                return
            }
            
            let isSuccess = data["success"] as! Bool
            let msg = data["msg"] as! String
            
            if isSuccess == true {
                
                print("成功, \(msg)")
            }
            
        }
       
        
    }
}
