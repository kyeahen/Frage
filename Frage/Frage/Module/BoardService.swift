//
//  BoardService.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 15..
//  Copyright © 2018년 yeen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher

struct BoardService: APIService {
    
    // MARK: 게시글 조회(read)
    static func boardInit(completion: @escaping ([Board])->Void) {
        
        let URL = url("/board")
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in //변수명
            switch res.result { //통신이 되었냐 안되었냐가 나온다?
            case .success:
                
                if let value = res.result.value {
                    
                    //////// Codable /////////
                    //목적 : 서버랑 클라랑 데이터를 주고 받을 때, 내가 자동으로 오면서 메세지라는 키로 오는 것은 메세지에 담아주고, data라는 키로 오는 것은 데이터에 담아주고 그러한 과정
                    let decoder = JSONDecoder()
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    print("Dd")
                    do {
                        let boardData = try decoder.decode(BoardData.self, from: value)
                        
                        if boardData.message == "success" {
                            print("게시글 조회 성공")
                            completion(boardData.result)
                        }
                        
                    } catch {
                        print("변수 문제")
                    }
                    
                }
                
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    //MARK: 게시글 등록(create) - 이미지 무
    static func saveFrage(user_idx: String, title: String, category: String, content:String, completion: @escaping ()->Void) {

        let URL = url("/board/frage")

        let body: [String: Any] = [
            "user_idx" : user_idx,
            "title" : title,
            "category" : category,
            "content" : content
        ]

        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in

            switch res.result {
            case .success:
                if let value = res.result.value {

                    let message = JSON(value)["message"].string

                    if message == "success" {
                        print("이미지 무 통신 성공")
                        completion()
                    }
                }
                break

            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    //MARK: 리뷰 등록(create) - 이미지 유
    static func saveFrage(user_idx: String,title: String, category: String, content:String, photo: UIImage, completion: @escaping ()->Void) {
        let URL = url("/board/frage")
        
        
        let contentData = content.data(using: .utf8)
        let photoData = UIImageJPEGRepresentation(photo, 0.3)
        let titleData = title.data(using: .utf8)
        let categoryData = category.data(using: .utf8)
        let user_idxData = user_idx.data(using: .utf8)

        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(contentData!, withName: "content")
            multipartFormData.append(photoData!, withName: "frage_image", fileName: "photo.jpg", mimeType: "image/jpeg")
            multipartFormData.append(titleData!, withName: "title")
            multipartFormData.append(categoryData!, withName: "category")
            multipartFormData.append(user_idxData!, withName: "user_idx")
            
            
        }, to: URL, method: .post, headers: nil ) { (encodingResult) in
            
            switch encodingResult {
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _) :

                upload.responseData(completionHandler: {(res) in
                    switch res.result {
                    case .success :
                        print("hhhhhhhhhhhhhhhhhhhhh2")
                        if let value = res.result.value {
                            let message = JSON(value)["message"].string
                            print("ㄴㄴ\(message)")

                            if message == "success" {
                                print("이미지 업로드 성공")
                                completion()
                            }
                        }
                        
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                })
                
                break
                
            case .failure(let err):
                print(err.localizedDescription)
            }
            
        }
        
    }
}
