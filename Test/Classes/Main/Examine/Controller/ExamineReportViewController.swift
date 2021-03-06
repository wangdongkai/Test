//
//  ExamineReportViewController.swift
//  Test
//
//  Created by 王东开 on 2017/8/14.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import FMDB
import SVProgressHUD

class ExamineReportViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var correctAccuracyLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var classCorrectAccuracyLabel: UILabel!
    
    @IBOutlet weak var answerCorrectLabel: UILabel!
    @IBOutlet weak var answerWrongLabel: UILabel!
    @IBOutlet weak var answerUndoLabel: UILabel!
    
    @IBOutlet weak var answerCollection: UICollectionView!
    
    var submitModel: ExamineSubmitModel?
    //var dataArray: [ExamineItemModel]?
    //var answers: [ExamineAnswerModel]?
    var model: ExamineMainModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWith(image: "back", target: self, action: #selector(ExamineReportViewController.backClick))
        // Do any additional setup after loading the view.
    }

    // 全部解析
    @IBAction func allAnalysisClick() {
        
        for vc in self.navigationController!.childViewControllers {
            
            if vc.isKind(of: ExamineDetailViewController.self) {
                
                let detailVC = vc as! ExamineDetailViewController
                detailVC.refresh(isSubmit: true)

                self.navigationController?.popToViewController(detailVC, animated: true)

            }
        }

    }
    
    // 错题解析
    @IBAction func wrongAnalysisClick() {
        
        
    }
    
    // 重做一次
    @IBAction func redoClick() {
        
        
        guard let groupId = self.model!.groupId else {
            
            return
        }
                
        UserDefaults.standard.set(0, forKey: (self.model!.groupId!))
        UserDefaults.standard.synchronize()

        
        let url = "http://www.qxueyou.com/qxueyou/exercise/Exercise/updateNewExerRecordNew"
        
        weak var weakSelf = self
        
        NetworkTool.shareInstance.request(method: .GET, url: url, param: ["groupId": groupId]) { (_, success: Any?, error: Error?) in
            
            guard let data = success as? [String: Any] else {
                
                return
            }
            
            let isSuccess = data["success"] as! Bool
            
            if isSuccess == true {
                
                let vc = weakSelf?.navigationController?.childViewControllers[1] as! ExamineMainViewController
                
                weakSelf?.navigationController?.popToViewController(vc, animated: true)
            }
            
        }


    }
    
    
}

private extension ExamineReportViewController {
    
    func setupCollection() {
        
        title = "答题报告"
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        
        self.submitLabel.text = "\(formatter.string(from: date)) 提交"
        self.correctLabel.text = "\(self.submitModel!.correctCount)"
        self.totalLabel.text = "共 \(self.submitModel!.allCount)道题"
        self.titleLabel.text = self.model!.name
        
        let accuracy = CGFloat(self.submitModel!.correctCount) / CGFloat(self.submitModel!.allCount)
        
        self.correctAccuracyLabel.text = String(format: "%.2f%%", accuracy * 100)
        
        self.answerCorrectLabel.text = "对 \(self.submitModel!.correctCount)"
        self.answerWrongLabel.text = "错 \(self.submitModel!.doCount - Int(self.submitModel!.correctCount))"
        self.answerUndoLabel.text = "未做 \(self.submitModel!.allCount - self.submitModel!.doCount)"

        self.rankLabel.text = "\(self.model!.classRank ?? "")"
        self.classCorrectAccuracyLabel.text = "\(self.model!.classAccuracy ?? "")"
        
        self.answerCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.answerCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        
        layout.minimumInteritemSpacing = (self.answerCollection.frame.width - 40.0 * 5) / 5
        layout.minimumLineSpacing = 10

    }
}

extension ExamineReportViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.submitModel!.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for view in cell.contentView.subviews {
            
            if type(of: view) == UIButton.self || type(of: view) == UILabel.self {
                
                view.removeFromSuperview()
            }
        }
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.center = cell.contentView.center
        
        button.setImage(UIImage(named: "circle"), for: .normal)
        button.isUserInteractionEnabled = false
        cell.contentView.addSubview(button)
        
        let label = UILabel(frame: button.bounds)
        label.center = button.center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.textAlignment = .center
        label.text = "\(indexPath.row + 1)"
        cell.contentView.addSubview(label)

        let item = self.submitModel!.items[indexPath.row]
        
        if indexPath.row == self.submitModel!.currTitleNum - 1 { //当前题号
            
            
        }
        
        if item.answer == "" { //未做
            
            //button.setImage(UIImage(named: "circle"), for: .normal)
              button.setBackgroundImage(UIImage(named: "circle"), for: .normal)
            if self.submitModel!.currTitleNum == indexPath.row + 1 {
                
                //button.setImage(UIImage(named: "glass"), for: .normal)
                //button.setTitle("", for: .normal)
                
            }
        } else {
            
            let image = item.correct == 1 ? UIImage(named: "circle_green") : UIImage(named: "circle_red")
            button.setBackgroundImage(image, for: .normal)
            
            if self.submitModel!.currTitleNum == indexPath.row + 1 {
                
                //button.setImage(UIImage(named: "glass_select"), for: .normal)
                //button.setTitle("", for: .normal)

            }

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for vc in self.navigationController!.childViewControllers {
            
            if vc.isKind(of: ExamineDetailViewController.self)  {
                
                let detailVC = vc as! ExamineDetailViewController
                detailVC.scrollCollection(index: indexPath.row + 1)

                self.navigationController?.popToViewController(detailVC, animated: true)

            }
        }
        

    }
}


private extension ExamineReportViewController {
    
    @objc func backClick() {
        
        let vc = self.navigationController?.childViewControllers[1] as! ExamineMainViewController
        
        self.navigationController?.popToViewController(vc, animated: true)
        
    }
}
