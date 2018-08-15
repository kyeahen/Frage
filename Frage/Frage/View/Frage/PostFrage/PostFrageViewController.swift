//
//  PostFrageViewController.swift
//  Frage
//
//  Created by Daigeun Sohn on 15/08/2018.
//  Copyright © 2018 yeen. All rights reserved.
//

import UIKit

class PostFrageViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categotyTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    let pickerView = UIPickerView()
    var partArr = ["Web", "App", "Server"]
    
    let imagePicker : UIImagePickerController = UIImagePickerController()
    
    var idx = UserDefaults.standard.string(forKey: "idx")
    override func viewDidLoad() {
        super.viewDidLoad()
        initPicker()
        print(gsno(idx))
    }
    
    @IBAction func openImagePicker(_ sender: UITapGestureRecognizer) {
        openGallery()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if titleTextField.text == "" || categotyTextField.text == "" || contentTextView.text == "" {
            let alertView = UIAlertController(title: "글 등록 실패", message: "다시 시도해주세요.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertView.addAction(ok)
            self.present(alertView, animated: true, completion: nil)
        }
        else {
            saveContent()
        }
    }
    
    func saveContent() {
        
        if let img = imageView.image { //이미지가 있을 때
            BoardService.saveFrage(user_idx: gsno(idx), title: gsno(titleTextField.text), category: gsno(categotyTextField.text), content: gsno(contentTextView.text), photo: img) {
                print("이미지 유 성공")
                let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabVC")
                self.present(tabVC, animated: true, completion: nil)
            }
        }

        else { //이미지가 없을 때
            BoardService.saveFrage(user_idx: gsno(idx), title: gsno(titleTextField.text), category: gsno(categotyTextField.text), content: gsno(contentTextView.text)) {
                print("이미지 무 성공")
                let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabVC")
                self.present(tabVC, animated: true, completion: nil)
            }
        }
    }

}

extension PostFrageViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        setTextfieldView(textField: categotyTextField, selector: #selector(selectedPicker), inputView: pickerView)
        
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
        
        categotyTextField.text = partArr[row]
        
        view.endEditing(true)
    }
}

// MARK: 이미지 첨부
extension PostFrageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Method
    @objc func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: { print("이미지 피커 나옴") })
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: { print("이미지 피커 나옴") })
        }
    }
    
    // imagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("사용자가 취소함")
        self.dismiss(animated: true) {
            print("이미지 피커 사라짐")
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        defer {
        //            self.dismiss(animated: true) {
        //                print("이미지 피커 사라짐")
        //            }
        //        }
        
        if let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = originalImage
        }
        
        self.dismiss(animated: true) {
            print("이미지 피커 사라짐")
        }
    }
    
}





