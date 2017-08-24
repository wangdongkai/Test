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
    var dataArray: [ExamineItemModel]?
    var answers: [ExamineAnswerModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWith(image: "back", target: self, action: #selector(ExamineReportViewController.backClick))
        // Do any additional setup after loading the view.
    }

    // 全部解析
    @IBAction func allAnalysisClick() {
        
        let vc = self.navigationController?.childViewControllers[2] as! ExamineAnaysisViewController
        
        self.navigationController?.popToViewController(vc, animated: true)

    }
    
    // 错题解析
    @IBAction func wrongAnalysisClick() {
        
        
    }
    
    // 重做一次
    @IBAction func redoClick() {
        
        SVProgressHUD.show()
        
        guard let groupId = self.dataArray?[0].exerciseGroupId else {
            
            return
        }
                
        UserDefaults.standard.set(0, forKey: (self.dataArray?[0].exerciseGroupId!)!)
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
        
        var correct = 0
        for answer in self.answers! {
            
            if answer.correct == 1 {
                
                correct += 1
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date.init(timeIntervalSince1970: (self.answers![0].createTime?.doubleValue)! / 1000.0)
        
        self.submitLabel.text = "\(formatter.string(from: date)) 提交"
        self.correctLabel.text = "\(correct)"
        self.totalLabel.text = "共 \(self.dataArray!.count)道题"
        
        let accuracy = CGFloat(correct) / CGFloat(self.dataArray!.count)
        
        self.correctAccuracyLabel.text = String(format: "%.2f%%", accuracy * 100)
        
        self.answerCorrectLabel.text = "对 \(correct)"
        self.answerWrongLabel.text = "错 \(self.answers!.count - correct)"
        self.answerUndoLabel.text = "未做 \(self.dataArray!.count - self.answers!.count)"

        
        let classRank = UserDefaults.standard.object(forKey: "\(self.dataArray![0].exerciseGroupId!)classRank") as! String
        let classAccuracy = UserDefaults.standard.object(forKey: "\(self.dataArray![0].exerciseGroupId!)classAccuracy") as! String
        
        print("\(self.dataArray![0].exerciseGroupId!)classRank")
        
        self.rankLabel.text = classRank
        self.classCorrectAccuracyLabel.text = classAccuracy
        
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
        
        return self.dataArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
                //let itemModel = self.answers![indexPath.row]
        
        
        for view in cell.contentView.subviews {
            
            if type(of: view) == UIButton.self || type(of: view) == UILabel.self {
                
                view.removeFromSuperview()
            }
        }
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.center = cell.contentView.center
        
        button.setImage(UIImage(named: "circle"), for: .normal)

        cell.contentView.addSubview(button)
        
        let label = UILabel(frame: button.bounds)
        label.center = button.center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.textAlignment = .center
        label.text = "\(indexPath.row + 1)"
        cell.contentView.addSubview(label)

        let item = self.dataArray![indexPath.row]
        
        for answer in self.answers! {
            
            if item.exerciseId == answer.exerciseItemId {
                
                if answer.answer == nil {
                    
                    button.setImage(UIImage(named: "circle"), for: .normal)
                    
                } else {
                    
                    let image = answer.correct?.intValue == 1 ? UIImage(named: "circle_green") : UIImage(named: "circle_red")
                    button.setImage(image, for: .normal)
                    
                }
                
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}


private extension ExamineReportViewController {
    
    @objc func backClick() {
        
        let vc = self.navigationController?.childViewControllers[1] as! ExamineMainViewController
        
        self.navigationController?.popToViewController(vc, animated: true)
        
    }
}
