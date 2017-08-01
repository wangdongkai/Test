//
//  LoginViewController.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - 属性
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        title = "登录"
        
        setupUI()
        
        // Do any additional setup after loading the view.
    }

    
    // MARK: - 事件
    @IBAction func loginClick() {
        
        if userTextField.text!.isEmpty {
            
            let alertVC = UIAlertController(title: "提示", message: "请输入手机号", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertVC.addAction(action)
            
            self.present(alertVC, animated: true, completion: nil)
            
            return
        }
        
        if passTextField.text!.isEmpty {
            
            let alertVC = UIAlertController(title: "提示", message: "请输入密码", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertVC.addAction(action)
            
            self.present(alertVC, animated: true, completion: nil)
            
            return
        }
        
        let examineVC = ExamineMainViewController()
        self.navigationController?.pushViewController(examineVC, animated: true)
        

    }
    
}

// MARK: - 扩展
private extension LoginViewController {
    
    func setupUI() {
        
        loginButton.layer.cornerRadius = 5.0
        loginButton.layer.masksToBounds = false
        
    }
    
}
