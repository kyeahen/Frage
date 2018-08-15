//
//  Comment.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 15..
//  Copyright © 2018년 yeen. All rights reserved.
//

import Foundation

struct Comment: Codable {
    
    let content: String
    let date: String
    let user_idx: Int
    let name: String
}
