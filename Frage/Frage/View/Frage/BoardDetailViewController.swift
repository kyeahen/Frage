//
//  BoardDetailViewController.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 14..
//  Copyright © 2018년 yeen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BoardDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var tit: String?
    var category: String?
    var part: String?
    var time: String?
    var name: String?
    var content: String?
    var img: String?
    var b_idx: String?
    
    @IBOutlet weak var tvComment: UITextView!
    var comments: [Comment] = [Comment]()
    var keyboardDismissGesture: UITapGestureRecognizer?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentSendView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        commentInit()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        setKeyboardSetting()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        commentInit()
        setKeyboardSetting()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: *테이블뷰*
    
    // MARK: numberOfSections
    // 테이블 뷰의 section이 몇 개인지 명시
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // MARK: numberOfRowsInSection
    // DataSource의 메소드
    // 테이블 뷰의 섹션안의 row가 몇 개인지 명시
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return comments.count
        }
    }
    
    // MARK: cellForRowAt
    // DataSource의 메소드
    // row에 어떤 데이터가 들어갈지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BoardDetailTableViewCell.reuseIdentifier) as! BoardDetailTableViewCell
            
            
            cell.nameLabel.text = name
            cell.categoryLabel.text = category
            cell.contentLabel.text = content
            cell.partLabel.text = part
            cell.timeLabel.text = time
            cell.titleLabel.text = tit
            
            // 이미지 받기
            // with : 이미지 경로
            // placeholder : 경로가 null일 때 기본으로 뜨게 할 이미지(UIImage 타입)
            //url로 오는 이미지를 이미지화 시켜야 함
            //킹피셔 = 자동으로 이미지뷰에 이미지를 넣어쥼
            
            cell.fimageView?.kf.setImage(with: URL(string: gsno(img)), placeholder: UIImage())
            
            return cell
            
        }
            
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.reuseIdentifier) as! CommentTableViewCell

            cell.nameLabel.text = comments[indexPath.row].name
            cell.contentLabel.text = comments[indexPath.row].content
            cell.timeLabel.text = comments[indexPath.row].date

            return cell
//
        }
        
    }
    
    
    // MARK: 댓글 조회(read)
    func commentInit() {
        
        let URL =  "http://13.209.243.155:3000/reply?board_idx=\(gsno(b_idx))"
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in //변수명
            
            switch res.result { //통신이 되었냐 안되었냐가 나온다?
                
            case .success:
                
                if let value = res.result.value {

                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let commentData = try decoder.decode(CommentData.self, from: value)
                        
                        if commentData.message == "success" {
                            print("message")
                            self.comments = commentData.result //디코드해서 받아온 데이터
                            self.tableView.reloadData()
                            
                        }
                        
                    } catch {
                        print("변수문제")
                    }
                    
                }
                
                break
                
            case .failure(let err):
                
                print(err.localizedDescription)
                break
            }
        }
    }
    
    @IBAction func onSend(_ sender: UIButton) {
        
        if tvComment.text.isEmpty == true {
            let dialog = UIAlertController(title: "댓글 등록 실패", message: "모든 항목을 입력하세요", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default)
            
            dialog.addAction(action)
            
            self.present(dialog, animated: true, completion: nil)
            
        }
            
        else {
            var user_idx = UserDefaults.standard.string(forKey: "idx")
            self.saveComment(board_idx: gsno(b_idx), user_idx: gsno(user_idx), content: self.tvComment.text)
            
        }
    }
    
    
    
    // MARK: 댓글 저장(create)
    func saveComment(board_idx: String, user_idx: String, content: String) {

        let URL = "http://13.209.243.155:3000/reply"

        let userdefault = UserDefaults.standard

        let body: [String: Any] = [

            "user_idx" : gsno(userdefault.string(forKey: "idx")), //값이 있으면 값이 나오고 없으면 default 값이 나온다. 옵셔널값 푸는 것
            "board_idx" : board_idx,
            "content" : content,
        ]

        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in

            switch res.result {

            case .success:

                if let value = res.result.value {

                    print("댓글 등록 성공")
                    self.tvComment.text = ""
                    self.viewDidLoad()

                }

                break


            case .failure(let err):

                print("댓글 등록 실패")

                print(err.localizedDescription)

                break
            }
        }
    }
}

extension BoardDetailViewController {
    
    //////// 외우지 않아도 되는 부분입니다. 표시된 부분만 고쳐서 사용하세요. ////////
    // 코드 설명 : 키보드가 나올 때 키보드의 높이를 계산해서 댓글 뷰가 키보드 위에 뜰 수 있도록 합니다.
    //          view.frame을 조정하면 키보드가 나오고 들어갈 때 뷰가 움직이게 되겠지요?
    //          notification : 옵저버라고 생각하시면 됩니다. 시점을 캐치하여 #selector()의 액션이 일어나도록 합니다.
    //                          이 코드에서는 키보드가 나올 때, 들어갈 때 의 시점을 캐치하여 뷰의 frame을 조정합니다.
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //////// 키보드의 사이즈만큼 commentSendView의 y축을 위로 이동시킴 ////////
            commentSendView.frame.origin.y -=
                keyboardSize.height
            ////////
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //////// 키보드의 사이즈만큼 commentSendView의 y축을 아래로 이동시킴 ////////
            commentSendView.frame.origin.y +=
                keyboardSize.height
            ////////
            self.view.layoutIfNeeded()
        }
    }
    
    func adjustKeyboardDismissGesture(isKeyboardVisible: Bool) {
        if isKeyboardVisible {
            if keyboardDismissGesture == nil {
                keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
                view.addGestureRecognizer(keyboardDismissGesture!)
            }
        } else {
            if keyboardDismissGesture != nil {
                view.removeGestureRecognizer(keyboardDismissGesture!)
                keyboardDismissGesture = nil
            }
        }
    }
    
    @objc func tapBackground() {
        self.view.endEditing(true)
    }
    ////////
}



