//
//  BoardData.swift
//  Frage
//
//  Created by 김예은 on 2018. 8. 15..
//  Copyright © 2018년 yeen. All rights reserved.
//

import Foundation

struct BoardData: Codable {
    
    let status: Bool
    let message: String
    let result: [Board]
}
