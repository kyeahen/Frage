//
//  SignService.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 15..
//  Copyright © 2018년 yeen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct SignService: APIService {
    
    //MARK: 로그인 서비스
    static func login(id: String, pwd: String, completion: @escaping (_ message: String) -> Void){
        
        let URL = url("/users/signin")
        
        let body: [String: Any] = [
            "id" : id,
            "pwd" : pwd
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            switch res.result{
            case .success:
                if let value = res.result.value{
                    
                    if let message = JSON(value)["message"].string{
                        UserDefaults.standard.set(JSON(value)["result"]["idx"].int, forKey: "idx")
                        
                        if message == "success"{ // 로그인 성공
                            print("성공")
                            
                            completion("success")
                        }
                        else{ // 로그인 실패
                            print("로그인 실패 : " + message)
                            
                            completion("failure")
                        }
                    }
                }
                
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    
    //MARK: 회원가입 서비스
    static func signUp(id: String, pwd: String, name: String, major: String, intro: String, completion: @escaping (_ message: String) -> Void){
        
        let URL = url("/users/signup")
        
        let body: [String: Any] = [
            "id" : name,
            "pwd" : id,
            "name" : pwd,
            "major" : major,
            "intro" : intro
            ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData(){ res in
            switch res.result{
            case .success:
                if let value = res.result.value{
                    
                    if let message = JSON(value)["message"].string{
                        
                        print("Dd")
                        
                        if message == "success"{ // 회원가입 성공
                            print("성공")
                            completion("success")
                        }
                        else { // 중복 있음
                            print("실패")
                            completion("failure")
                        }
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
