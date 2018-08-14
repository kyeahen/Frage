//
//  ViewController.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 14..
//  Copyright © 2018년 yeen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: 로그인
    @IBAction func LoginAction(_ sender: UIButton) {
        login()
    }
    
    func login() {
        SignService.login(id: gsno(idTextField.text), pwd: gsno(pwdTextField.text)) { (message) in
            if message == "success"{
                let boardNaviVC = UIStoryboard(name: "Board", bundle: nil).instantiateViewController(withIdentifier: "BoardNaviVC")
                self.present(boardNaviVC, animated: true, completion: nil)
            }
            else {
                let alertView = UIAlertController(title: "로그인 실패", message: "다시 시도해주세요.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertView.addAction(ok)
                self.present(alertView, animated: true, completion: nil)
            }
            
        }
        
    }
    

    
}

