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
import RealmSwift

private let identifier = "ExamineDetailsViewCell"

class ExamineDetailViewController: UICollectionViewController {

    var model: ExamineMainModel?
    var submitModel: ExamineSubmitModel = ExamineSubmitModel()
    
    var items: [ExamineItemModel] = [ExamineItemModel]()
    var answers: [ExamineAnswerModel] = [ExamineAnswerModel]()
    
    var submitDataArray: [[String: ExamineItemModel]] = [[String: ExamineItemModel]]()
    
    fileprivate let button: UIButton = UIButton(type: .custom)
    
    fileprivate var timer: Timer?
    
    var index: Int = 0

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
        return self.items.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ExamineDetailsViewCell
        
        
        let model = self.items[indexPath.row]
    
        model.totalCount = self.items.count
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
        
        //setupDataBase(cell: cell)

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

        self.model?.exerciseTimer = UserDefaults.standard.integer(forKey: (self.model?.groupId)!)
        
        self.view.backgroundColor = UIColor.white
        self.collectionView?.backgroundColor = UIColor.clear
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.barButtonItemWith(image: "submit", target: self, action: #selector(ExamineDetailViewController.submit)),
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
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ExamineDetailViewController.timeClick), userInfo: nil, repeats: true)
        
       
    }
    
    @objc func setupNetwork() {
        
        let param = ["groupId": model?.groupId! ?? "", "exerciseRecordId": model?.exerciseRecordId ?? "", "getExercise": true, "getAnswer": true] as [String : Any]
        
        weak var weakSelf = self
        
        NetworkTool.shareInstance.get("http://www.qxueyou.com/qxueyou/exercise/Exercise/examExercise", parameters: param, progress: nil, success: { (_, data: Any?) in
            
            guard let dict = data as? [String: Any] else {
                
                return
            }
            
            let detailModel: ExamineDetailModel = ExamineDetailModel.mj_object(withKeyValues: dict)
            //weakSelf?.setupRealm(result: detailModel.items!)
            if detailModel.answers != nil{
                weakSelf?.setupRealm(answerItems: detailModel.answers!)

            }
            
            weakSelf?.items = detailModel.items!
            if detailModel.answers != nil {
                weakSelf?.answers = detailModel.answers!
            }
            
            weakSelf?.collectionView?.reloadData()
            
            if weakSelf!.index > 0 {
                let indexPath = IndexPath(item: weakSelf!.index - 1, section: 0)
                if indexPath.row != weakSelf!.items.count {
                    weakSelf!.collectionView?.scrollToItem(at: indexPath, at: .right, animated: true)
                    
                }

            }
            
            
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
        
        UserDefaults.standard.set(self.model?.exerciseTimer, forKey: (self.model?.groupId)!)

        if self.submitModel.items.count > 0 {
            

            let alertVC = UIAlertController(title: "提示", message: "您已经回答了\(self.submitModel.items.count)道题(共\(self.model!.allCount)题)，您打算？", preferredStyle: .alert)
            
            weak var weakSelf = self
            
            let actionNext = UIAlertAction(title: "下次继续", style: .default) { (_) in
                
                weakSelf?.submitClick(status: 0)
                
                weakSelf?.navigationController?.popViewController(animated: true)
                
            }
            
            let actionSubmit = UIAlertAction(title: "提交", style: .destructive) { (_) in
                
                weakSelf?.submit()
                weakSelf?.navigationController?.popViewController(animated: true)

            }
            
            alertVC.addAction(actionNext)
            alertVC.addAction(actionSubmit)
            
            self.present(alertVC, animated: true, completion: nil)

        } else {
            
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    // 提交
    @objc func submitClick(status: Int) {
    
        self.submitModel.allCount = self.model!.allCount
        self.submitModel.doCount = self.submitModel.items.count
        
        if self.submitModel.items.count == 0 {
            
            let alertVC = UIAlertController(title: "提示", message: "请回答一道题之后在提交", preferredStyle: .alert)
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
        self.submitModel.exerciseGroupId = self.items[0].exerciseGroupId
        self.submitModel.exerciseRecordId = self.items[0].exerciseRecordId ?? ""
        self.submitModel.exerciseExtendId = self.items[0].exerciseExtendId ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.submitModel.submitTime = formatter.string(from: Date())
        
        self.submitModel.status = status
                
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
                
                let vc = ExamineReportViewController.init(nibName: "ExamineReportViewController", bundle: nil)
                //vc.answers = detailModel.answers
                vc.dataArray = self.items
                self.navigationController?.pushViewController(vc, animated: true)

                print("成功, \(msg)")
                
            }
            
        }
       
    }
    
    @objc func staticstisClick() {
        
        self.submitModel.allCount = self.model!.allCount
        self.submitModel.doCount = self.submitModel.items.count
        
        for i in 0..<self.submitModel.items.count {
            
            let item = self.submitModel.items[i]
                        
            if item.correct == 1 {
                
                self.submitModel.correctCount += 1
            }
        }
        self.submitModel.exerciseGroupId = self.items[0].exerciseGroupId
        self.submitModel.exerciseRecordId = self.items[0].exerciseRecordId
        self.submitModel.exerciseExtendId = self.items[0].exerciseExtendId
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.submitModel.submitTime = formatter.string(from: Date())
        
        self.submitModel.status = 1
        
        let vc = ExamineStaticssticsViewController.init(nibName: "ExamineStaticssticsViewController", bundle: Bundle.main)
        vc.dataArray = self.items
        vc.submitModel = self.submitModel
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @objc func timeClick() {
        
        let h = self.model!.exerciseTimer / 3600
        let m = (self.model!.exerciseTimer - h * 3600) / 60
        let s = self.model!.exerciseTimer - h * 3600 - m * 60
        
        let title = "\(h):\(m):\(s)"
        
        self.button.setTitle(title, for: .normal)
        self.model?.exerciseTimer -= 1

        if self.model?.exerciseTimer == 0 {
            
            self.submit()
            
            self.timer?.invalidate()
        }
    }
}

extension ExamineDetailViewController {
    
    func submit() {
        
        submitClick(status: 1)
        
    }
    
    func network() {
        
        setupNetwork()
        
    }
}

private extension ExamineDetailViewController {
    
    /// 数据库添加文件
    func setupRealm(itemModels: [ExamineItemModel]) {
        
        DispatchQueue(label: "ExamineItemModel").async {
            
            autoreleasepool{
                
                let realm = try! Realm()
                
                realm.beginWrite()
                
                for item in itemModels {
                    
                    let tanTopic = realm.objects(TopicDetail.self).filter("exerciseId = '\(item.exerciseId!)'")
                    
                    if tanTopic.count == 0 {
                        //realm.create(TopicDetail.self, value: value, update: false)
                        
                        let analisis = TopicAnalisis(value: ["allAccuracy": item.analisisResult!["allAccuracy"],
                                                             "analysis": item.analisisResult!["analysis"],
                                                             "submitAllNumber": item.analisisResult!["submitAllNumber"],
                                                             "accuracy": item.analisisResult!["accuracy"],
                                                             "submitNumber": item.analisisResult!["submitNumber"],
                                                             "submitErrorNumber": item.analisisResult!["submitErrorNumber"]])
                        
                        let options = List<TopicOptions>()
                        for option in item.options! {
                            /*
                            dynamic var optionId: String? = nil
                            dynamic var content: String? = nil
                            dynamic var optionOrder: String? = nil
                            dynamic var exerciseId: String? = nil
                            */
                            
                            options.append(TopicOptions(value: [option.optionId!, option.content!, option.optionOrder!, option.exerciseItemId]))
                        }
                        
                        let imgs = List<TopicImgs>()
                        
                        if item.imgs != nil && item.imgs?.count == 0 {
                            for img in item.imgs! {
                                
                                imgs.append(TopicImgs(value: img.imgURL))
                            }

                        }
                        
                        /*
                         dynamic var exerciseId: String? = nil
                         dynamic var title: String? = nil
                         dynamic var type: Int = 0
                         dynamic var updateTime: Float = 0
                         dynamic var answer: String? = nil
                         let options = List<TopicOptions>()
                         dynamic var analisisResult:TopicAnalisis?
                         let imgs = List<TopicImgs>()
                         dynamic var maxScore: Float = 0
                         dynamic var avarageScore: Float = 0
                         */

                        //detail.analisisResult = analisis
                        
                        let detail = TopicDetail(value: [
                                                        
                            
                            
                            
                                                        ])
                        print("detail = \(detail)")
                        
                        try! realm.write({ 
                            realm.add(detail)
                            
                        })
                    } else {
                        
                        let result = tanTopic[0]
                        //realm.create(TopicDetail.self, value: value, update: true)
                    }
                    
                }
                
                try! realm.commitWrite()
            }
            
        }
    }
    
    func setupRealm(answerItems: [ExamineAnswerModel]) {
        
        DispatchQueue(label: "ExamineAnswerModel").async {
            
            autoreleasepool{
                
                let realm = try! Realm()
                
                realm.beginWrite()
                
                for item in answerItems {
                    
                    let tanTopic = realm.objects(TopicAnswer.self).filter("answerUId = '\(item.answerUId!)'")
                    
                    let value: [String: Any] = ["answerUId": item.answerUId, "answer": item.answer, "correct": item.correct?.intValue,"createTime": item.createTime, "creator": item.creator, "exerciseItemId": item.exerciseItemId, "exerciseRecordId": item.exerciseRecordId, "userId": item.userId, "lastAnswer": item.lastAnswer, "answerValue": item.answerValue, "updateStatus": item.updateStatus]
                    
                    if tanTopic.count == 0 {
                        realm.create(TopicAnswer.self, value: value, update: false)
                    } else {
                        
                        realm.create(TopicAnswer.self, value: value, update: true)
                    }
                    
                }
                
                try! realm.commitWrite()
            }

        }
    }
}


extension ExamineDetailViewController {
    
    func scrollCollection(index: Int) {
        
        if index > 0 {
            let indexPath = IndexPath(item: index - 1, section: 0)
            if indexPath.row != self.items.count {
                self.collectionView?.scrollToItem(at: indexPath, at: .right, animated: true)
                
            }
            
        }

    }
}
