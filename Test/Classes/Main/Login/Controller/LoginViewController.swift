//
//  LoginViewController.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD
import FMDB

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
        
        
        let url = "http://www.qxueyou.com/qxueyou/sys/login/loginNew/\(userTextField.text!)"
        SVProgressHUD.show(withStatus: "登录中...")
        
        NetworkTool.shareInstance.request(method: .GET, url: url, param: ["password": passTextField.text!]) { (task: URLSessionDataTask, success: Any?, error: Error?) in
            
            SVProgressHUD.dismiss()
            
            if let _ = error {
                
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                
                return
            }
            guard let dict = success as? Dictionary<String, Any> else {
                
                return
            }
            guard let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: url)!) else {
                
                return
            }
            var cookieDict: Dictionary<String, Any> = [String: Any]()
            var cookieValue: String = String()
            
            for cookie in cookies {
                
                cookieDict[cookie.name] = cookie.value
            
            }
            
            for key in cookieDict {
                
                cookieValue.append("\(key.key)=\(key.value);")
            }
            
            UserDefaults.standard.set(cookieValue, forKey: "Cookie")
            UserDefaults.standard.set(self.userTextField.text!, forKey: "username")
            UserDefaults.standard.synchronize()
            
            self.setupDataBase(name: self.userTextField.text!)
            
            let examineVC = ExamineMainViewController()
            examineVC.model = UserModel(dict: dict)
            
            self.navigationController?.pushViewController(examineVC, animated: true)

            SVProgressHUD.dismiss()
            
        }
        
        
        
        
    }
    
}

// MARK: - 扩展
private extension LoginViewController {
    
    func setupUI() {
        
        loginButton.layer.cornerRadius = 5.0
        loginButton.layer.masksToBounds = false
        
    }
    
    func setupDataBase(name: String) {
        
        let path: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
        
        let sqlPath = path.appendingPathComponent("\(name).sqlite")
        let db = FMDatabase(path: sqlPath)
        
        if db.open() {
            print("open success")
        }
    }

    }

