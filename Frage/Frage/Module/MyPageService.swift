//
//  MyPageService.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 15..
//  Copyright © 2018년 yeen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct MyPageService: APIService {
    
    //MARK: 마이페이지
    static func myPageInit(completion: @escaping (MyPage) -> Void) {
        let idx = UserDefaults.standard.string(forKey: "idx")!
        let URL = url("/mypage?user_idx=\(idx)")
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
            case .success:
                
                if let value = res.result.value {
                    
                    print("계정설정 접근")
                    let decoder = JSONDecoder()
                    
                    do {
                        print("계정설정 진입")
                        
                        let myPageData = try decoder.decode(MyPageData.self, from: value)
                                                    
                        if myPageData.status == true {
                            let message = JSON(value)["message"].string

                            if myPageData.message == "success" {
                                print("계정 설정 성공")
                                completion(myPageData.result)
                            }
                            else {
                                print("계정 설정 실패")
                            }
                            
                        }
                        else {
                            print("서버 에러")
                        }
                        
                    } catch {
                        print("서버 에러")
                    }
                    
                }
                
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
        
    }
}
