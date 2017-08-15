//
//  ExamineReportViewController.swift
//  Test
//
//  Created by 王东开 on 2017/8/14.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
        
        // Do any additional setup after loading the view.
    }

    // 全部解析
    @IBAction func allAnalysisClick() {
        
        
    }
    
    // 错题解析
    @IBAction func wrongAnalysisClick() {
        
        
    }
    
    // 重做一次
    @IBAction func redoClick() {
        
        let vc = self.navigationController?.childViewControllers[2] as! ExamineDetailViewController
        
        vc.network()
        vc.submitModel = ExamineSubmitModel()
        
        vc.collectionView?.reloadData()
        
        vc.index = 0
        
        self.navigationController?.popViewController(animated: true)

    }
    
    
}

private extension ExamineReportViewController {
    
    func setupCollection() {
        
        title = "答题报告"
        
        self.submitLabel.text = "\(self.submitModel!.submitTime!) 提交"
        self.correctLabel.text = "\(self.submitModel!.correctCount)"
        self.totalLabel.text = "共 \(self.submitModel!.allCount)道题"

        let accuracy = CGFloat(self.submitModel!.correctCount) / CGFloat(self.submitModel!.allCount)
        
        self.correctAccuracyLabel.text = String(format: "%.2f%%", accuracy * 100)
        
        self.answerCorrectLabel.text = "对 \(self.submitModel!.correctCount)"
        self.answerWrongLabel.text = "错 \(self.submitModel!.doCount - self.submitModel!.correctCount)"
        self.answerUndoLabel.text = "未做 \(self.submitModel!.allCount - self.submitModel!.doCount)"

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
        
        let itemModel = self.dataArray![indexPath.row]
        
        for view in cell.contentView.subviews {
            
            if type(of: view) == UIButton.self || type(of: view) == UILabel.self {
                
                view.removeFromSuperview()
            }
        }
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.center = cell.contentView.center
        
        if itemModel.chooseAnswer == nil {
            
            button.setImage(UIImage(named: "circle"), for: .normal)

        } else {
            
            let image = itemModel.chooseAnswer == itemModel.ans ? UIImage(named: "circle_green") : UIImage(named: "circle_red")
            button.setImage(image, for: .normal)

        }
        cell.contentView.addSubview(button)
        
        let label = UILabel(frame: button.bounds)
        label.center = button.center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.textAlignment = .center
        label.text = "\(indexPath.row + 1)"
        cell.contentView.addSubview(label)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
