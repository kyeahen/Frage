//
//  Board.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 15..
//  Copyright © 2018년 yeen. All rights reserved.
//

import Foundation

struct Board: Codable {
    
    let board_idx: Int
    let name: String
    let major: String
    let frage_image: String?
    let title: String?
    let category: Int?
    let date: String?
    let content: String?
    

}
