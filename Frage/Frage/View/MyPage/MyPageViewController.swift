//
//  MyPageViewController.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 14..
//  Copyright © 2018년 yeen. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: UILabel!
    @IBOutlet weak var idTextField: UILabel!
    @IBOutlet weak var partTextField: UILabel!
    @IBOutlet weak var introTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myPageInit()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func myPageInit()  {
        MyPageService.myPageInit() { (myPageData) in
            print("통신 시작")
            
            self.nickNameTextField.text = self.gsno(myPageData.name)
            self.idTextField.text = self.gsno(myPageData.id)
             self.partTextField.text = self.gsno(myPageData.major)
            self.introTextView.text = self.gsno(myPageData.intro)
        }

    }


}
