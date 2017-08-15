//
//  ExamineDetailViewController.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import MJExtension
import MJRefresh

private let identifier = "ExamineDetailsViewCell"

class ExamineDetailViewController: UICollectionViewController {

    var model: ExamineMainModel?
    var submitModel: ExamineSubmitModel = ExamineSubmitModel()
    
    var dataArray: [ExamineItemModel] = [ExamineItemModel]()
    var submitDataArray: [[String: ExamineItemModel]] = [[String: ExamineItemModel]]()
    
    fileprivate let button: UIButton = UIButton(type: .custom)
    
    fileprivate var timer: DispatchSourceTimer?
    
    var index: Int = 0 {
        didSet {
            
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .right, animated: true)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        setupButton()
        
        setupNetwork()
        
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
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
        let cell = collectionView?.cellForItem(at: index!) as! ExamineDetailsViewCell
        
        if cell.submitModel.answer.characters.count > 0 {
            
            self.submitModel.currTitleNum = index!.item
            
            if self.submitModel.items.contains(cell.submitModel) == false{
                
                self.submitModel.items.append(cell.submitModel)
            }
            
        }

        self.submitModel.currTitleNum = index!.item
        
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        
        let point = self.view.convert(self.collectionView!.center, to: self.collectionView)
        let index = self.collectionView?.indexPathForItem(at: point)
        
        let cell = collectionView?.cellForItem(at: index!) as! ExamineDetailsViewCell
        
        print(cell.submitModel)
        
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWith(image: "back", target: self, action: #selector(ExamineDetailViewController.backClick))
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0

        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height - 64)
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.register(UINib.init(nibName: "ExamineDetailsViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)

        self.collectionView?.isPagingEnabled = true
        
        
    }
    
    func setupButton() {
        
        self.button.frame = CGRect(x: self.view.frame.width - 50 - 15, y: self.view.frame.height - 100, width: 50, height: 50)
        self.button.layer.cornerRadius = 25.0
        self.button.layer.masksToBounds = false
        self.button.setTitleColor(UIColor.white, for: .normal)
        self.button.backgroundColor = UIColor.colorWithHex(color: "2196F3", alpha: 1.0)
        self.button.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        
        self.button.addTarget(self, action: #selector(ExamineDetailViewController.staticstisClick), for: .touchUpInside)
        self.view.insertSubview(self.button, aboveSubview: self.collectionView!)
        
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global(qos: .default))
        timer?.scheduleRepeating(deadline: .now(), interval: 1.0)
        
        weak var weakSelf = self
        
        timer?.setEventHandler(handler: { 
            
            let h = self.model!.exerciseTimer / 3600
            let m = (self.model!.exerciseTimer - h * 3600) / 60
            let s = self.model!.exerciseTimer - h * 3600 - m * 60
            
            let title = "\(h):\(m):\(s)"

            weakSelf?.button.setTitle(title, for: .normal)
            weakSelf?.model?.exerciseTimer -= 1

            
        })
        
        timer?.resume()
        
    }
    
    func setupNetwork() {
        
        let param = ["groupId": model?.groupId! ?? "", "exerciseRecordId": model?.exerciseRecordId! ?? "", "getExercise": true, "getAnswer": true] as [String : Any]
        
        weak var weakSelf = self
        
        NetworkTool.shareInstance.get("http://www.qxueyou.com/qxueyou/exercise/Exercise/examExercise", parameters: param, progress: nil, success: { (_, data: Any?) in
            
            guard let dict = data as? [String: Any] else {
                
                return
            }

            let detailModel: ExamineDetailModel = ExamineDetailModel.mj_object(withKeyValues: dict)
                        
            weakSelf?.dataArray = detailModel.items!
            
            weakSelf?.collectionView?.reloadData()
            
        }) { (_, error: Error) in
            
            print(error)
            

        }
    }
}

private extension ExamineDetailViewController {
    
    // 收藏
    @objc func collectClick() {
        
        
    }
    
    // 返回
    @objc func backClick() {
        
        let alertVC = UIAlertController(title: "提示", message: "您已经回答了\(self.submitModel.items.count)道题(共\(self.model!.allCount)题)，您打算？", preferredStyle: .alert)
        
        weak var weakSelf = self
        
        let actionNext = UIAlertAction(title: "下次继续", style: .default) { (_) in
            
            weakSelf?.navigationController?.popViewController(animated: true)
            
        }
        
        let actionSubmit = UIAlertAction(title: "提交", style: .destructive) { (_) in
            
            
        }
        
        alertVC.addAction(actionNext)
        alertVC.addAction(actionSubmit)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // 提交
    @objc func submitClick() {
    
        self.submitModel.allCount = self.model!.allCount
        self.submitModel.doCount = self.submitModel.items.count
        
        if self.submitModel.items.count == 0 {
            
            let alertVC = UIAlertController(title: "提示", message: "您已经回答了\(self.submitModel.items.count)道题(共\(self.model!.allCount)题)，您打算？", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            
            alertVC.addAction(action)
            
            self.present(alertVC, animated: true, completion: nil)
            return
        }
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
                
                let vc = ExamineReportViewController.init(nibName: "ExamineReportViewController", bundle: nil)
                vc.submitModel = self.submitModel
                vc.dataArray = self.dataArray
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
       
        
    }
    
    // 计时
    @objc func staticstisClick() {
                
        let vc = ExamineStaticssticsViewController.init(nibName: "ExamineStaticssticsViewController", bundle: Bundle.main)
        vc.dataArray = self.dataArray
        vc.submitModel = self.submitModel
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

extension ExamineDetailViewController {
    
    func submit() {
        
        submitClick()
        
    }
    
    func network() {
        
        setupNetwork()
        
    }
}
