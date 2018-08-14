//
//  JoinViewController.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 14..
//  Copyright © 2018년 yeen. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController, APIService{
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var partTextField: UITextField!
    @IBOutlet weak var introTextView: UITextView!
    
    let pickerView = UIPickerView()
    var partArr = ["product manager", "designer", "developer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPicker()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: 회원가입 액션
    @IBAction func joinAction(_ sender: Any) {
        
        if nicknameTextField.text == "" || idTextField.text == "" || pwdTextField.text == "" || partTextField.text == "" || introTextView.text == "" {
                let alertView = UIAlertController(title: "회원가입 실패", message: "모든 항목을 입력해주세요.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertView.addAction(ok)
                self.present(alertView, animated: true, completion: nil)
        }
        else {
            signUp()
        }
    }
    
    func signUp(){
    
        SignService.signUp(id: gsno(idTextField.text), pwd: gsno(pwdTextField.text), name: gsno(nicknameTextField.text), major: gsno(partTextField.text), intro: gsno(introTextView.text)){ message in
            
            if message == "success"{
                self.navigationController?.popViewController(animated: true)
            }
            else {
                let alertView = UIAlertController(title: "회원가입 실패", message: "다시 시도해주세요.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertView.addAction(ok)
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
}

extension JoinViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    //UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //UIPickerViewDelegate
    //컴포넌트 당 row 가 몇개가 될 것인가
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return partArr.count
    }
    
    ///UIPickerViewDataSource 위한 것
    //각각의 row 에 어떠한 내용이 들어갈 것인가
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return partArr[row]
        
    }
    
    func initPicker(){
        //구현 후에 해당 pickerView의 데이터 소스와 델리게이트가 있는 위치 알려 주는 것
        pickerView.delegate = self
        pickerView.dataSource = self
        
        setTextfieldView(textField: partTextField, selector: #selector(selectedPicker), inputView: pickerView)
        
    }
    
//    func initDatePicker(){
//
//        datePicker.datePickerMode = .date
//
//        let dateFormatter = DateFormatter()
//
//        dateFormatter.dateFormat = "yyyy.MM.dd"
//
//        guard let date = dateFormatter.date(from: "1996.01.29") else {
//            fatalError("포맷과 맞지 않아 데이터 변환이 실패했습니다")
//        }
//
//        datePicker.date = date
//
//        datePicker.maximumDate = Date()
//
//
//        setTextfieldView(textField: textBirth, selector: #selector(selectedDatePicker), inputView: datePicker)
//    }
    
    func setTextfieldView(textField:UITextField, selector : Selector, inputView : Any){
        
        let bar = UIToolbar()
        bar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: .done
            , target: self, action: selector)
        
        bar.setItems([doneButton], animated: true)
        textField.inputAccessoryView = bar
        
        if let tempView = inputView as? UIView {
            textField.inputView = tempView
        }
        if let tempView = inputView as? UIControl {
            textField.inputView = tempView
        }
        
    }
    
//    @objc func selectedDatePicker(){
//
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy.MM.dd"
//
//        let date = dateformatter.string(from: datePicker.date)
//
//        textBirth.text = date
//
//        view.endEditing(true)
//    }
//
    
    @objc func selectedPicker(){
        
        let row = pickerView.selectedRow(inComponent: 0)
        
        partTextField.text = partArr[row]
        
        view.endEditing(true)
    }
}


