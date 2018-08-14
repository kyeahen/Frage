//
//  Frage.swift
//  Frage
//
//  Created by Daigeun Sohn on 15/08/2018.
//  Copyright © 2018 yeen. All rights reserved.
//

import Foundation

class FrageStore {
    
    var frages: [Frage] = []
    
    public static let shared: FrageStore = FrageStore()
    
    private init() { }
    
    public func getTestFrages(completion: (() -> Void)?) {
        frages.removeAll()
        
        for _ in 0...5 {
            let frage = Frage.testFrage()
            frages.append(frage)
        }
        
        completion?()
    }
}

struct Author {
    var authorType: String = ""
    var name: String = ""
    var id: String = ""
}

struct Frage {
    var id: Int = 0
    var title: String = ""
    var imageUrls: [String] = []
    var contents: String = ""
    var author: Author = Author()
//    var authorId: String = ""
//    var authorName: String = ""
    var replies: [FrageReply] = []
    var category: String = ""
    
    public static func testFrage() -> Frage {
        var frage = Frage()
        frage.title = "Hello, fdfdfsads"
        frage.contents = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
//        frage.authorName = "daigeun"
        frage.author.name = "daigeun"
        frage.author.authorType = "Designer"
        frage.category = "Mobile App"
        return frage
    }
}

struct FrageReply {
    var frageId: Int = 0
    var contents: String = ""
    var authorId: String = ""
}
